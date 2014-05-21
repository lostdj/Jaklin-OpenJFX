/*
 * Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved.
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

/*
 * This file was originally generated by JSLC
 * and then hand edited for performance.
 */

package com.sun.scenario.effect.impl.sw.sse;

import com.sun.scenario.effect.Effect;
import com.sun.scenario.effect.FilterContext;
import com.sun.scenario.effect.ImageData;
import com.sun.scenario.effect.impl.HeapImage;
import com.sun.scenario.effect.impl.Renderer;
import com.sun.javafx.geom.Rectangle;
import com.sun.javafx.geom.transform.BaseTransform;
import com.sun.scenario.effect.impl.state.BoxRenderState;

public class SSEBoxBlurPeer extends SSEEffectPeer<BoxRenderState> {

    public SSEBoxBlurPeer(FilterContext fctx, Renderer r, String uniqueName) {
        super(fctx, r, uniqueName);
    }

    @Override
    public ImageData filter(Effect effect,
                            BoxRenderState brstate,
                            BaseTransform transform,
                            Rectangle outputClip,
                            ImageData... inputs)
    {
        setRenderState(brstate);
        // NOTE: for now, all input images must be TYPE_INT_ARGB_PRE

        boolean horizontal = (getPass() == 0);

        // Calculate the amount the image grows on each iteration (size-1)
        int hinc = horizontal ? brstate.getBoxPixelSize(0) - 1 : 0;
        int vinc = horizontal ? 0 : brstate.getBoxPixelSize(1) - 1;
        int iterations = brstate.getBlurPasses();
        if (iterations < 1 || (hinc < 1 && vinc < 1)) {
            inputs[0].addref();
            return inputs[0];
        }
        // Calculate the amount the image will grow through the full operation
        // Always upgrade to the next even amount of growth
        int growx = (hinc * iterations + 1) & (~0x1);
        int growy = (vinc * iterations + 1) & (~0x1);

        // Assert: rstate.getEffectTransformSpace() == UserSpace
        // NOTE: We could still have a transformed ImageData for other reasons...
        HeapImage src = (HeapImage)inputs[0].getUntransformedImage();
        Rectangle srcr = inputs[0].getUntransformedBounds();

        HeapImage cur = src;
        int curw = srcr.width;
        int curh = srcr.height;
        int curscan = cur.getScanlineStride();
        int[] curPixels = cur.getPixelArray();

        int finalw = curw + growx;
        int finalh = curh + growy;
        while (curw < finalw || curh < finalh) {
            int neww = curw + hinc;
            int newh = curh + vinc;
            if (neww > finalw) neww = finalw;
            if (newh > finalh) newh = finalh;
            HeapImage dst = (HeapImage)getRenderer().getCompatibleImage(neww, newh);
            int newscan = dst.getScanlineStride();
            int[] newPixels = dst.getPixelArray();
            if (horizontal) {
                filterHorizontal(newPixels, neww, newh, newscan,
                                 curPixels, curw, curh, curscan);
            } else {
                filterVertical(newPixels, neww, newh, newscan,
                               curPixels, curw, curh, curscan);
            }
            if (cur != src) {
                getRenderer().releaseCompatibleImage(cur);
            }
            cur = dst;
            curw = neww;
            curh = newh;
            curPixels = newPixels;
            curscan = newscan;
        }

        Rectangle dstBounds =
            new Rectangle(srcr.x - growx/2, srcr.y - growy/2, curw, curh);
        return new ImageData(getFilterContext(), cur, dstBounds);
    }

    private static native void
        filterHorizontal(int dstPixels[], int dstw, int dsth, int dstscan,
                         int srcPixels[], int srcw, int srch, int srcscan);

    private static native void
        filterVertical(int dstPixels[], int dstw, int dsth, int dstscan,
                       int srcPixels[], int srcw, int srch, int srcscan);
}
