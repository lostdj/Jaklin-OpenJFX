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
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 */

package javafx.scene.paint;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import javafx.animation.Interpolatable;

import org.junit.Test;

import com.sun.javafx.Utils;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;

public class ColorTest {
    
    @Test
    public void testRedIsBoundedBy0And1() {
        try {
            Color c = new Color(-1, 0, 0, 0);
            assertTrue(false);
        } catch (Exception e) {}
        
        try {
            Color c = new Color(100, 0, 0, 0);
            assertTrue(false);
        } catch (Exception ee) {}
    }

    @Test
    public void testGreenIsBoundedBy0And1() {
        try {
            Color c = new Color(0, -1, 0, 0);
            assertTrue(false);
        } catch (Exception e) {}

        try {
            Color c = new Color(0, 100, 0, 0);
            assertTrue(false);
        } catch (Exception ee) {}
    }
    
    @Test
    public void testBlueIsBoundedBy0And1() {
        try {
            Color c = new Color(0, 0, -1, 0);
            assertTrue(false);
        } catch (Exception e) {}

        try {
            Color c = new Color(0, 0, 100, 0);
            assertTrue(false);
        } catch (Exception ee) {}
    }

    @Test
    public void testOpacityIsBoundedBy0And1() {
        try {
            Color c = new Color(0, 0, 0, -1);
            assertTrue(false);
        } catch (Exception e) {}

        try {
            Color c = new Color(0, 0, 0, 100);
            assertTrue(false);
        } catch (Exception ee) {}
    }
    
    @Test
    public void testOfTheWay() {
        Color start = new Color(0, 0, 0, 0);
        Color end = new Color(1, 1, 1, 1);
        Color mid = start.interpolate(end, .5);
        assertEquals(mid.getRed(), .5, 0.0001);
        assertEquals(mid.getGreen(), .5, 0.0001);
        assertEquals(mid.getBlue(), .5, 0.0001);
        assertEquals(mid.getOpacity(), .5, 0.0001);
    }

    @Test
    public void testOfTheWayAll()
        throws IllegalArgumentException, IllegalAccessException
    {
        ArrayList<Color> colors = new ArrayList<Color>();
        for (Field f : Color.class.getDeclaredFields()) {
            if (Modifier.isStatic(f.getModifiers()) &&
                f.getType() == Color.class)
            {
                Color c = (Color) f.get(null);
                colors.add(c);
            }
        }
        for (Color c1 : colors) {
            for (Color c2 : colors) {
                c1.interpolate(c2, 0.0);
                c1.interpolate(c2, Double.MIN_VALUE);
                c1.interpolate(c2, 0.5);
                c1.interpolate(c2, 1.0 - Double.MIN_VALUE);
                c1.interpolate(c2, 1.0);
            }
        }
    }

    @Test
    public void testOfTheWayIndirect() {
        Interpolatable<Color> start = new Color(0, 0, 0, 0);
        Color end = new Color(1, 1, 1, 1);
        Color mid = start.interpolate(end, .5);
        assertEquals(mid.getRed(), .5, 0.0001);
        assertEquals(mid.getGreen(),.5, 0.0001);
        assertEquals(mid.getBlue(), .5, 0.0001);
        assertEquals(mid.getOpacity(), .5, 0.0001);
    }
    
    @Test
    public void testColorIsBoundedBy0And1() {
        try {
            Color color = Color.color(-1, 0, 0, 0);
            assertTrue(false);
        } catch (Exception e) {}
        
        try {
            Color color = Color.color(0, -1, 0, 0);
            assertTrue(false);
        } catch (Exception ee) {}

        try {
            Color color = Color.color(0, 0, -1, 0);
            assertTrue(false);
        } catch (Exception eee) {}

        try {
            Color color = Color.color(0, 0, 0, -1);
            assertTrue(false);
        } catch (Exception eeee) {}

        try {
            Color color = Color.color(2, 0, 0, 0);
            assertTrue(false);
        } catch (Exception eeeee) {}

        try {
            Color color = Color.color(0, 2, 0, 0);
            assertTrue(false);
        } catch (Exception eeeeee) {}

        try {
            Color color = Color.color(0, 0, 2, 0);
            assertTrue(false);
        } catch (Exception eeeeeee) {}

        try {
            Color color = Color.color(0, 0, 0, 2);
            assertTrue(false);
        } catch (Exception eeeeeeee) {}
    }
    
    @Test
    public void testColor() {
        Color color = Color.color(.1, .2, .3);
        assertEquals(.1, color.getRed(), 0.0001);
        assertEquals(.2, color.getGreen(), 0.0001);
        assertEquals(.3, color.getBlue(), 0.0001);
        assertEquals(1, color.getOpacity(), 0.0001);
    }
    
    @Test
    public void testColorWithOpacity() {
        Color color = Color.color(.1, .2, .3, .4);
        assertEquals(.1, color.getRed(), 0.0001);
        assertEquals(.2, color.getGreen(), 0.0001);
        assertEquals(.3, color.getBlue(), 0.0001);
        assertEquals(.4, color.getOpacity(), 0.0001);
    }

    @Test
    public void testRgbIsBoundedBy0And255() {
        try {
            Color color = Color.rgb(-1, 0, 0, 0);
            assertTrue(false);
        } catch (Exception e) {}
        
        try {
            Color color = Color.rgb(0, -1, 0, 0);
            assertTrue(false);
        } catch (Exception ee) {}

        try {
            Color color = Color.rgb(0, 0, -1, 0);
            assertTrue(false);
        } catch (Exception eee) {}

        try {
            Color color = Color.rgb(0, 0, 0, -1);
            assertTrue(false);
        } catch (Exception eeee) {}

        try {
            Color color = Color.rgb(300, 0, 0, 0);
            assertTrue(false);
        } catch (Exception eeeee) {}

        try {
            Color color = Color.rgb(0, 300, 0, 0);
            assertTrue(false);
        } catch (Exception eeeeee) {}

        try {
            Color color = Color.rgb(0, 0, 300, 0);
            assertTrue(false);
        } catch (Exception eeeeeee) {}

        try {
            Color color = Color.rgb(0, 0, 0, 300);
            assertTrue(false);
        } catch (Exception eeeeeeee) {}
    }
    
    @Test
    public void testRgb() {
        Color color = Color.rgb(255, 0, 255, 0);
        assertTrue(color.getRed() == 1);
        assertTrue(color.getGreen() == 0);
        assertTrue(color.getBlue() == 1);
        assertTrue(color.getOpacity() == 0);
        double[] hsb = Utils.RGBtoHSB(1.0, 0.0, 1.0);
        assertEquals(hsb[0], color.getHue(), 0.0001);
        assertEquals(hsb[1], color.getSaturation(), 0.0001);
        assertEquals(hsb[2], color.getBrightness(), 0.0001);
    }
    
    @Test
    public void testGray() {
        Color color = Color.gray(0.5);
        assertEquals(0.5, color.getRed(), 0.0001);
        assertEquals(0.5, color.getGreen(), 0.0001);
        assertEquals(0.5, color.getBlue(), 0.0001);
        assertEquals(1.0, color.getOpacity(), 0.0001);
    }

    @Test
    public void testGrayWithOpacity() {
        Color color = Color.gray(0.5, 0.3);
        assertEquals(0.5, color.getRed(), 0.0001);
        assertEquals(0.5, color.getGreen(), 0.0001);
        assertEquals(0.5, color.getBlue(), 0.0001);
        assertEquals(0.3, color.getOpacity(), 0.0001);
    }

    @Test
    public void testGrayRgb() {
        Color color = Color.grayRgb(255, 0.5);
        assertEquals(1.0, color.getRed(), 0.0001);
        assertEquals(1.0, color.getGreen(), 0.0001);
        assertEquals(1.0, color.getBlue(), 0.0001);
        assertEquals(0.5, color.getOpacity(), 0.0001);
    }

    @Test
    public void testHsbIsBounded() {
        Color.hsb(10000, 0, 0); // this should work!
    
        try {
            Color color = Color.hsb(100, -1, 0);
            assertTrue(false);
        } catch (Exception ee) {}
    
        try {
            Color color = Color.hsb(100, 0, -1);
            assertTrue(false);
        } catch (Exception eee) {}
    
        try {
            Color color = Color.hsb(100, 2, 0);
            assertTrue(false);
        } catch (Exception eeee) {}
    
        try {
            Color color = Color.hsb(100, 0, 2);
            assertTrue(false);
        } catch (Exception eeeee) {}
    }
    
    @Test
    public void testHsb() {
        Color color = Color.hsb(210, 1, .5);
        assertEquals(0.0, color.getRed(), .0001);
        assertEquals(0.25, color.getGreen(), .0001);
        assertEquals(0.5, color.getBlue(), .0001);
        assertEquals(1.0, color.getOpacity(), .0001);
        assertEquals(210, color.getHue(), 0.0001);
        assertEquals(1.0, color.getSaturation(), 0.0001);
        assertEquals(0.5, color.getBrightness(), 0.0001);
    }

    @Test
    public void testHsbWithOpacity() {
        Color color = Color.hsb(210, 1, .5, .4);
        assertEquals(0.0, color.getRed(), .0001);
        assertEquals(0.25, color.getGreen(), .0001);
        assertEquals(0.5, color.getBlue(), .0001);
        assertEquals(0.4, color.getOpacity(), .0001);
        assertEquals(210, color.getHue(), 0.0001);
        assertEquals(1.0, color.getSaturation(), 0.0001);
        assertEquals(0.5, color.getBrightness(), 0.0001);
    }

    @Test
    public void testWebPoundNotation() {
        Color color = Color.web("#aabbcc");
        assertEquals(color.getRed(), 170.0/255.0, 0.0001);
        assertEquals(color.getGreen(), 187.0/255.0, 0.0001);
        assertEquals(color.getBlue(), 204.0/255.0, 0.0001);
    }

    @Test
    public void testWebPoundNotationShort() {
        Color color = Color.web("#abc");
        assertEquals(color.getRed(), 10.0/15.0, 0.0001);
        assertEquals(color.getGreen(), 11.0/15.0, 0.0001);
        assertEquals(color.getBlue(), 12.0/15.0, 0.0001);
    }

    @Test
    public void testWebPoundNotationWithAlphaAndOpacity() {
        Color color = Color.web("#aabbcc80", 0.5);
        assertEquals(color.getRed(), 170.0/255.0, 0.0001);
        assertEquals(color.getGreen(), 187.0/255.0, 0.0001);
        assertEquals(color.getBlue(), 204.0/255.0, 0.0001);
        assertEquals((128.0/255.0)/2.0, color.getOpacity(), 0.0001);
    }

    @Test(expected=IllegalArgumentException.class)
    public void testWebPoundNotationIllegalValue() {
        Color.web("#aabbccddee");
    }

    @Test(expected=NullPointerException.class)
    public void testWebNullValue() {
        Color.web(null);
    }

    @Test(expected=IllegalArgumentException.class)
    public void testWebEmptyColor() {
        Color.web("", 0.5);
    }
    
    @Test
    public void testWebHexNotation() {
        Color color = Color.web("0xaabbcc");
        assertEquals(color.getRed(), 170.0/255.0, 0.0001);
        assertEquals(color.getGreen(), 187.0/255.0, 0.0001);
        assertEquals(color.getBlue(), 204.0/255.0, 0.0001);
    }
    
    @Test
    public void testWebHexNotationWithAlpha() {
        Color color = Color.web("0xaabbcc80");
        assertEquals(color.getRed(), 170.0/255.0, 0.0001);
        assertEquals(color.getGreen(), 187.0/255.0, 0.0001);
        assertEquals(color.getBlue(), 204.0/255.0, 0.0001);
        assertEquals(128.0/255.0, color.getOpacity(), 0.0001);
    }

    @Test(expected=IllegalArgumentException.class)
    public void testWebHexNotationIllegalValue() {
        Color.web("0xaabbccddee");
    }
    
    @Test
    public void testWebNamed() {
        Color color = Color.web("orangered");
        Color expected = Color.rgb(0xFF, 0x45, 0x00);
        assertTrue(expected.getRed() == color.getRed());
        assertTrue(expected.getGreen() == color.getGreen());
        assertTrue(expected.getBlue() == color.getBlue());
        assertTrue(expected.getOpacity() == color.getOpacity());
        double[] hsb = Utils.RGBtoHSB(1.0, 69.0/255.0, 0.0);
        assertEquals(hsb[0], color.getHue(), 0.001);
        assertEquals(hsb[1], color.getSaturation(), 0.001);
        assertEquals(hsb[2], color.getBrightness(), 0.001);
    }
    
    @Test
    public void testWebNamedWithOpacity() {
        Color color = Color.web("orangered", 0.4);
        Color expected = Color.rgb(0xFF, 0x45, 0x00, 0.4);
        assertTrue(expected.getRed() == color.getRed());
        assertTrue(expected.getGreen() == color.getGreen());
        assertTrue(expected.getBlue() == color.getBlue());
        assertTrue(expected.getOpacity() == color.getOpacity());
    }

    @Test
    public void testWebNamedMixedCase() {
        Color color = Color.web("oRAngEReD");
        Color expected = Color.rgb(0xFF, 0x45, 0x00);
        assertTrue(expected.getRed() == color.getRed());
        assertTrue(expected.getGreen() == color.getGreen());
        assertTrue(expected.getBlue() == color.getBlue());
        assertTrue(expected.getOpacity() == color.getOpacity());
    }
    
    @Test(expected=IllegalArgumentException.class)
    public void testWebNamedWrongName() {
        Color.web("foobar");
    }

    @Test
    public void testWebHex0xNotation() {
        Color color = Color.web("0xaabbcc");
        assertEquals(color.getRed(), 170.0/255.0, 0.0001);
        assertEquals(color.getGreen(), 187.0/255.0, 0.0001);
        assertEquals(color.getBlue(), 204.0/255.0, 0.0001);
    }

    @Test
    public void testWebHex0xNotationShort() {
        Color color = Color.web("0xabc");
        assertEquals(color.getRed(), 10.0/15.0, 0.0001);
        assertEquals(color.getGreen(), 11.0/15.0, 0.0001);
        assertEquals(color.getBlue(), 12.0/15.0, 0.0001);
    }

    @Test
    public void testWebHexNoLeadingSymbol() {
        Color color = Color.web("aAbBcC");
        assertEquals(color.getRed(), 170.0/255.0, 0.0001);
        assertEquals(color.getGreen(), 187.0/255.0, 0.0001);
        assertEquals(color.getBlue(), 204.0/255.0, 0.0001);
    }

    @Test
    public void testWebHexNoLeadingSymbolShort() {
        Color color = Color.web("aBc");
        assertEquals(color.getRed(), 10.0/15.0, 0.0001);
        assertEquals(color.getGreen(), 11.0/15.0, 0.0001);
        assertEquals(color.getBlue(), 12.0/15.0, 0.0001);
    }

    @Test
    public void testWebHexNoLeadingSymbolShortWithAlpha() {
        Color color = Color.web("aBc9");
        assertEquals(color.getRed(), 10.0/15.0, 0.0001);
        assertEquals(color.getGreen(), 11.0/15.0, 0.0001);
        assertEquals(color.getBlue(), 12.0/15.0, 0.0001);
        assertEquals(0.6, color.getOpacity(), 0.0001);
    }

    @Test
    public void testDeriveColor() {
        Color original = Color.hsb(180, 0.4, 0.8, 0.5);
        Color color = original.deriveColor(-90, 2, 0.5, 2);
        assertEquals(90, color.getHue(), 0.0001);
        assertEquals(0.8, color.getSaturation(), 0.0001);
        assertEquals(0.4, color.getBrightness(), 0.0001);
        assertEquals(1.0, color.getOpacity(), 0.0001);
    }

    @Test
    public void testDeriveColorFromRgb() {
        Color original = Color.rgb(128, 0, 255);
        double[] hsb = Utils.RGBtoHSB(128.0/255.0, 0.0, 1.0);
        Color color = original.deriveColor(-30, 0.5, 0.5, 0.5);
        assertEquals((hsb[0] - 30), color.getHue(), 0.0001);
        assertEquals(hsb[1] / 2, color.getSaturation(), 0.0001);
        assertEquals(hsb[2] / 2, color.getBrightness(), 0.0001);
        assertEquals(0.5, color.getOpacity(), 0.0001);
    }

    @Test
    public void testDeriveColorClipS() {
        Color original = Color.hsb(180, 0.4, 0.8, 0.5);
        Color color = original.deriveColor(-1170, -5, 20, -5);
        assertEquals(0, color.getHue(), 0.0001);
        assertEquals(0.0, color.getSaturation(), 0.0001);
        assertEquals(1.0, color.getBrightness(), 0.0001);
        assertEquals(0.0, color.getOpacity(), 0.0001);
    }

    @Test
    public void testDeriveColorClipHB() {
        Color original = Color.hsb(180, 0.4, 0.8, 0.5);
        Color color = original.deriveColor(-1170, 1.0, 20, -5);
        assertEquals(90, color.getHue(), 0.0001);
        assertEquals(0.4, color.getSaturation(), 0.0001);
        assertEquals(1.0, color.getBrightness(), 0.0001);
        assertEquals(0.0, color.getOpacity(), 0.0001);
    }

    @Test
    public void testDarker() {
        Color original = Color.hsb(180, 0.4, 0.8, 0.5);
        Color color = original.darker();
        assertEquals(180, color.getHue(), 0.0001);
        assertEquals(0.4, color.getSaturation(), 0.0001);
        assertEquals(0.56, color.getBrightness(), 0.0001);
        assertEquals(0.5, color.getOpacity(), 0.0001);
    }

    @Test
    public void testBrighter() {
        Color original = Color.hsb(180, 0.4, 0.4, 0.5);
        Color color = original.brighter();
        assertEquals(180, color.getHue(), 0.0001);
        assertEquals(0.4, color.getSaturation(), 0.0001);
        assertEquals(0.5714, color.getBrightness(), 0.0001);
        assertEquals(0.5, color.getOpacity(), 0.0001);
    }

    @Test
    public void testBlackBrighter() {
        Color color = Color.BLACK.brighter();
        assertTrue(color.getBrightness() > 0.0);
        assertEquals(color.getRed(), color.getGreen(), 0.0001);
        assertEquals(color.getRed(), color.getBlue(), 0.0001);
    }

    @Test
    public void testSaturate() {
        Color original = Color.hsb(180, 0.4, 0.4, 0.5);
        Color color = original.saturate();
        assertEquals(180, color.getHue(), 0.0001);
        assertEquals(0.5714, color.getSaturation(), 0.0001);
        assertEquals(0.4, color.getBrightness(), 0.0001);
        assertEquals(0.5, color.getOpacity(), 0.0001);
    }

    @Test
    public void testDesaturate() {
        Color original = Color.hsb(180, 0.8, 0.4, 0.5);
        Color color = original.desaturate();
        assertEquals(180, color.getHue(), 0.0001);
        assertEquals(0.56, color.getSaturation(), 0.0001);
        assertEquals(0.4, color.getBrightness(), 0.0001);
        assertEquals(0.5, color.getOpacity(), 0.0001);
    }

    @Test
    public void testInvert() {
        Color original = Color.color(0.2, 0.3, 0.4, 0.6);
        Color color = original.invert();
        assertEquals(0.8, color.getRed(), 0.0001);
        assertEquals(0.7, color.getGreen(), 0.0001);
        assertEquals(0.6, color.getBlue(), 0.0001);
        assertEquals(0.6, color.getOpacity(), 0.0001);
    }

    @Test
    public void testGreyscale() {
        Color original = Color.color(0.2, 0.3, 0.4, 0.6);
        Color color = original.grayscale();
        assertEquals(0.283, color.getRed(), 0.0001);
        assertEquals(0.283, color.getGreen(), 0.0001);
        assertEquals(0.283, color.getBlue(), 0.0001);
        assertEquals(0.6, color.getOpacity(), 0.0001);
    }

    @Test
    public void testEquals() {
        Color basic = Color.rgb(0, 0, 0, 0.5);
        Color equal = Color.rgb(0, 0, 0, 0.5);
        Color color1 = Color.rgb(0xAA, 0, 0, 0.5);
        Color color2 = Color.rgb(0, 0xAA, 0, 0.5);
        Color color3 = Color.rgb(0, 0, 0xAA, 0.5);
        Color color4 = Color.rgb(0, 0, 0, 0.6);

        assertFalse(basic.equals(null));
        assertFalse(basic.equals(new Object()));
        assertTrue(basic.equals(basic));
        assertTrue(basic.equals(equal));
        assertFalse(basic.equals(color1));
        assertFalse(basic.equals(color2));
        assertFalse(basic.equals(color3));
        assertFalse(basic.equals(color4));
    }

    @Test
    public void testHashCode() {
        Color basic = Color.rgb(0, 0, 0, 0.5);
        Color equal = Color.rgb(0, 0, 0, 0.5);
        Color diffColor = Color.rgb(0, 0xAA, 0, 0.5);
        Color diffOpacity = Color.rgb(0, 0, 0, 0.7);
        Color transparent = Color.rgb(0, 0, 0, 0.0);

        int code = basic.hashCode();
        int second = basic.hashCode();
        assertTrue(code == second);
        assertTrue(code == equal.hashCode());
        assertFalse(code == diffColor.hashCode());
        assertFalse(code == diffOpacity.hashCode());
        assertEquals(0, Color.TRANSPARENT.hashCode());
        assertEquals(0, transparent.hashCode());
    }

    @Test
    public void testToString() {
        Color color = Color.rgb(0, 0, 0, 0.0);

        String s = color.toString();
        assertNotNull(s);
        assertFalse(s.isEmpty());
    }

    //function testOfTheWayHandlesNegatives() {
        // TODO should this be tested? What does it mean?
    //}
    
    //function testOfTheWayHandlesLargeNumbers() {
        // TODO What should happen for numbers > 1?
    //}

    @Test
    public void testBuilderDefaultOpacity() {
        Color color = ColorBuilder.create().red(0.125).green(0.25).blue(0.5).build();
        assertEquals(0.125, color.getRed(), 0);
        assertEquals(0.25, color.getGreen(), 0);
        assertEquals(0.5, color.getBlue(), 0);
        assertEquals(1, color.getOpacity(), 0);
    }

    @Test
    public void testBuilderDefaultEverything() {
        Color color = ColorBuilder.create().build();
        assertEquals(0, color.getRed(), 0);
        assertEquals(0, color.getGreen(), 0);
        assertEquals(0, color.getBlue(), 0);
        assertEquals(1, color.getOpacity(), 0);
    }

    @Test
    public void testBuilderExplicitEverything() {
        Color color = ColorBuilder.create().blue(0.5).red(0.75).green(0.875).opacity(0.625).build();
        assertEquals(0.5, color.getBlue(), 0);
        assertEquals(0.75, color.getRed(), 0);
        assertEquals(0.875, color.getGreen(), 0);
        assertEquals(0.625, color.getOpacity(), 0);
    }
}
