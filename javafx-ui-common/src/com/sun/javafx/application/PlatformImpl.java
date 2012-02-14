/*
 * Copyright (c) 2010, 2012, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

package com.sun.javafx.application;

import com.sun.javafx.runtime.SystemProperties;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import javafx.application.ConditionalFeature;

import com.sun.javafx.tk.TKListener;
import com.sun.javafx.tk.TKStage;
import com.sun.javafx.tk.Toolkit;

public class PlatformImpl {

    private static AtomicBoolean initialized = new AtomicBoolean(false);
    private static AtomicBoolean platformExit = new AtomicBoolean(false);
    private static AtomicBoolean toolkitExit = new AtomicBoolean(false);
    private static CountDownLatch startupLatch = new CountDownLatch(1);
    private static AtomicBoolean listenersRegistered = new AtomicBoolean(false);
    private static TKListener toolkitListener = null;
    private static AtomicInteger pendingRunnables = new AtomicInteger(0);
    private static AtomicInteger numWindows = new AtomicInteger(0);
    private static volatile boolean firstWindowShown = false;
    private static volatile boolean lastWindowClosed = false;
    private static AtomicBoolean reallyIdle = new AtomicBoolean(false);
    private static Set<FinishListener> finishListeners =
            new CopyOnWriteArraySet<FinishListener>();
    private final static Object runLaterLock = new Object();

    /**
     * This method is invoked typically on the main thread. At this point,
     * the JavaFX Application Thread has not been started. Any attempt
     * to call startup twice results in an exception.
     * @param r
     */
    public static void startup(final Runnable r) {

        // NOTE: if we ever support re-launching an application and/or
        // launching a second application in the same VM/classloader
        // this will need to be changed.
        if (platformExit.get()) {
            throw new IllegalStateException("Platform.exit has been called");
        }

        if (initialized.getAndSet(true)) {
            // If we've already initialized, just put the runnable on the queue.
            runLater(r);
            return;
        }

        // Create Toolkit listener and register it with the Toolkit.
        // Call notifyFinishListeners when we get notified.
        toolkitListener = new TKListener() {
            @Override public void changedTopLevelWindows(List<TKStage> windows) {
                numWindows.set(windows.size());
                checkIdle();
            }
        };
        Toolkit.getToolkit().addTkListener(toolkitListener);

        Toolkit.getToolkit().startup(new Runnable() {
            @Override public void run() {
                startupLatch.countDown();
                r.run();
            }
        });
    }

    private static void waitForStart() {
        // If the startup runnable has not yet been called, then wait it.
        // Note that we check the count before calling await() to avoid
        // the try/catch which is unnecessary after startup.
        if (startupLatch.getCount() > 0) {
            try {
                startupLatch.await();
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }

    public static boolean isFxApplicationThread() {
        return Toolkit.getToolkit().isFxUserThread();
    }

    public static void runLater(final Runnable r) {
        runLater(r, false);
    }

    private static void runLater(final Runnable r, boolean exiting) {
        if (!initialized.get()) {
            throw new IllegalStateException("Toolkit not initialized");
        }

        pendingRunnables.incrementAndGet();
        waitForStart();

        if (SystemProperties.isDebug()) {
            Toolkit.getToolkit().pauseCurrentThread();
        }

        synchronized (runLaterLock) {
            if (!exiting && toolkitExit.get()) {
                // Don't schedule a runnable after we have exited the toolkit
                pendingRunnables.decrementAndGet();
                return;
            }

            Toolkit.getToolkit().defer(new Runnable() {
                @Override public void run() {
                    try {
                        r.run();
                        pendingRunnables.decrementAndGet();
                        checkIdle();
                    } catch (Throwable t) {
                        System.err.println("Exception in runnable");
                        t.printStackTrace();
                    }
                }
            });
        }
    }

    public static void runAndWait(final Runnable r) {
        runAndWait(r, false);
    }

    private static void runAndWait(final Runnable r, boolean exiting) {
        if (SystemProperties.isDebug()) {
            Toolkit.getToolkit().pauseCurrentThread();
        }

        if (isFxApplicationThread()) {
             try {
                 r.run();
             } catch (Throwable t) {
                 System.err.println("Exception in runnable");
                 t.printStackTrace();
             }
        } else {
            final CountDownLatch doneLatch = new CountDownLatch(1);
            runLater(new Runnable() {
                @Override public void run() {
                    try {
                        r.run();
                    } catch (Throwable t) {
                        System.err.println("Exception in runnable");
                        t.printStackTrace();
                    } finally {
                        doneLatch.countDown();
                    }
                }
            }, exiting);

            if (!exiting && toolkitExit.get()) {
                throw new IllegalStateException("Toolkit has exited");
            }

            try {
                doneLatch.await();
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }

    public static void addListener(FinishListener l) {
        listenersRegistered.set(true);
        finishListeners.add(l);
    }

    public static void removeListener(FinishListener l) {
        finishListeners.remove(l);
        listenersRegistered.set(!finishListeners.isEmpty());
    }

    private static void notifyFinishListeners(boolean exitCalled) {
        for (FinishListener l : finishListeners) {
            if (exitCalled) {
                l.exitCalled();
            } else {
                l.idle();
            }
        }
    }

    // Check for idle, meaning the last top-level window has been closed and
    // there are no pending Runnables waiting to be run.
    private static void checkIdle() {
        boolean doNotify = false;

        synchronized (PlatformImpl.class) {
            int numWin = numWindows.get();
            if (numWin > 0) {
                firstWindowShown = true;
                lastWindowClosed = false;
                reallyIdle.set(false);
            } else if (numWin == 0 && firstWindowShown) {
                lastWindowClosed = true;
            }

            // In case there is an event in process, allow for it to show
            // another window. If no new window is shown before all pending
            // runnables (including this one) are done, then we will shutdown.
            if (lastWindowClosed && pendingRunnables.get() == 0) {
//                System.err.println("Last window closed and no pending runnables");
                if (reallyIdle.getAndSet(true)) {
//                    System.err.println("Really idle now");
                    doNotify = true;
                    lastWindowClosed = false;
                } else {
//                    System.err.println("Queuing up a dummy idle check runnable");
                    runLater(new Runnable() {
                        @Override public void run() {
//                            System.err.println("Dummy runnable");
                        }
                    });
                }
            }
        }

        if (doNotify) {
            notifyFinishListeners(false);
        }
    }

    public static void tkExit() {
        if (toolkitExit.getAndSet(true)) {
            return;
        }

        if (initialized.get()) {
            // Always call toolkit exit on FX app thread
//            System.err.println("PlatformImpl.tkExit: scheduling Toolkit.exit");
            PlatformImpl.runAndWait(new Runnable() {
                @Override public void run() {
//                    System.err.println("PlatformImpl.tkExit: calling Toolkit.exit");
                    Toolkit.getToolkit().exit();
                }
            }, true);

            Toolkit.getToolkit().removeTkListener(toolkitListener);
            toolkitListener = null;
        }
    }

    public static void exit() {
//        System.err.println("PlatformImpl.exit");
        platformExit.set(true);

        // Notify listeners if any are registered, else exit directly
        if (listenersRegistered.get()) {
            notifyFinishListeners(true);
        } else {
//            System.err.println("Platform.exit: calling doExit directly (no listeners)");
            tkExit();
        }
    }

    public static boolean isSupported(ConditionalFeature feature) {
        return Toolkit.getToolkit().isSupported(feature);
    }

    public static interface FinishListener {
        public void idle();
        public void exitCalled();
    }

}