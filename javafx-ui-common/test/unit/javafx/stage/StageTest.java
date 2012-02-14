/*
 * Copyright (c) 2011, 2012, Oracle and/or its affiliates. All rights reserved.
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
package javafx.stage;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertSame;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.StageBuilder;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.sun.javafx.pgstub.StubStage;
import com.sun.javafx.pgstub.StubToolkit;
import com.sun.javafx.tk.Toolkit;

public class StageTest {
    
    private StubToolkit toolkit;
    private Stage s;
    private StubStage peer;

    private int initialNumTimesSetSizeAndLocation;
    
    @Before
    public void setUp() {
        toolkit = (StubToolkit) Toolkit.getToolkit();
        s = new Stage();
        s.show();
        peer = (StubStage) s.impl_getPeer();
        initialNumTimesSetSizeAndLocation = peer.numTimesSetSizeAndLocation;
    }

    @After
    public void tearDown() {
        s.hide();
    }
    
    private void pulse() {
        toolkit.fireTestPulse();
    }
    
    /**
     * Simple test which checks whether changing the x/y position of the Stage
     * ends up invoking the appropriate methods on the TKStage interface.
     */
    public @Test void testMovingStage() {
        s.setX(100);
        pulse();
        assertEquals(100f, peer.x);
        // Setting X should result in a single call to peer.setBounds()
        assertEquals(1, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
    }

    /**
     * Simple test which checks whether changing the w/h size of the Stage
     * ends up invoking the appropriate methods on the TKStage interface.
     */
    public @Test void testResizingStage() {
        s.setWidth(100);
        s.setHeight(100);
        pulse();
        assertEquals(100f, peer.width);
        assertEquals(100f, peer.height);
        // Setting W and H should result in a single call to peer.setBounds()
        assertEquals(1, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
    }

    /**
     * Simple test which checks whether changing the w/h size and x/y position of the Stage
     * ends up invoking the appropriate methods on the TKStage interface.
     */
    public @Test void testMovingAndResizingStage() {
        s.setX(101);
        s.setY(102);
        s.setWidth(103);
        s.setHeight(104);
        pulse();
        assertEquals(101f, peer.x);
        assertEquals(102f, peer.y);
        assertEquals(103f, peer.width);
        assertEquals(104f, peer.height);
        // Setting X, Y, W and H should result in a single call to peer.setBounds()
        assertEquals(1, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
    }

    /**
     * Simple test which checks whether changing the minimum w/h of the Stage
     * resize the window if necessary
     */
    public @Test void testResizingTooSmallStage() {
        s.setWidth(60);
        s.setHeight(70);
        s.setMinWidth(150);
        s.setMinHeight(140);
        pulse();
        assertEquals(150.0, peer.width, 0.0001);
        assertEquals(140.0, peer.height, 0.0001);
    }

    /**
     * Simple test which checks whether changing the maximum w/h of the Stage
     * resize the window if necessary
     */
    public @Test void testResizingTooBigStage() {
        s.setWidth(100);
        s.setHeight(100);
        s.setMaxWidth(60);
        s.setMaxHeight(70);
        pulse();
        assertEquals(60.0, peer.width, 0.0001);
        assertEquals(70.0, peer.height, 0.0001);
    }

    /**
     * Test to make sure that when we initialize, the Stage doesn't notify
     * the peer of size and location more than once.
     */
    public @Test void testSizeAndLocationChangedOverTime() {
        // New stage with no dimension does not sync dimensions
        pulse();
        assertEquals(1, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
        // Oncethe width/height is set it is synced once on pulse
        s.setWidth(300);
        s.setHeight(400);
        pulse();
        assertEquals(300f, peer.width);
        assertEquals(400f, peer.height);
        assertEquals(2, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
        // Setting y will trigger one more sync
        s.setY(200);
        pulse();
        assertEquals(200f, peer.y);
        assertEquals(3, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
        // .. same for setting y
        s.setX(100);
        pulse();
        assertEquals(100f, peer.x);
        assertEquals(4, peer.numTimesSetSizeAndLocation - initialNumTimesSetSizeAndLocation);
    }

    /**
     * Test that StageBuilder includes all the expected properties (RT-13594, RT-13595).
     */
    public @Test void testStageBuilder() {
        Scene scene = new Scene(new Group());
        StageBuilder<?> builder = StageBuilder.create();
        // Usually builder calls are chained but because this is a test we write each one on its own line
        // so that if one of them fails to compile or throws an exception we can easily see which one it was.
        builder.focused(false);
        builder.fullScreen(false);
        builder.height(100);
        builder.width(200);
        builder.iconified(false);
        builder.icons(new Image[0]);
        builder.opacity(0.5);
        builder.resizable(false);
        builder.title("yes");
        builder.x(300);
        builder.y(400);
        builder.scene(scene);

        Stage stage = builder.build();
        stage.show();
        assertFalse(stage.isFocused());
        assertFalse(stage.isFullScreen());
        assertEquals(100.0, stage.getHeight(), 0);
        assertEquals(200.0, stage.getWidth(), 0);
        assertFalse(stage.isIconified());
        assertEquals(0, stage.getIcons().size());
        assertEquals(0.5, stage.getOpacity(), 0);
        assertEquals(false, stage.isResizable());
        assertEquals("yes", stage.getTitle());
        assertEquals(300.0, stage.getX(), 0);
        assertEquals(400.0, stage.getY(), 0);
        assertSame(scene, stage.getScene());
    }
}