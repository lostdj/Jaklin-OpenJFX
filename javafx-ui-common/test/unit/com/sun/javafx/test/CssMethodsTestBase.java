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

package com.sun.javafx.test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import javafx.scene.Node;

import org.junit.Test;

import com.sun.javafx.css.StyleConverter;
import com.sun.javafx.css.StyleableProperty;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javafx.beans.value.WritableValue;

public abstract class CssMethodsTestBase {
    private final Configuration configuration;

    public CssMethodsTestBase(final Configuration configuration) {
        this.configuration = configuration;
    }

    
    @Test // This _must_ be the first test!
    public void testCssDefaultSameAsPropertyDefault() {
        configuration.cssDefaultsTest();
    }
    
    @Test
    public void testStyleablePropertyAndCSSPropertyReferenceEachOther() {
        configuration.cssPropertyReferenceIntegrityTest();
    }
    
    @Test
    public void testCssSettable() throws Exception {
        configuration.cssSettableTest();
    }

    @Test
    public void testCssSet() {
        configuration.cssSetTest();
    }

    public static Object[] config(
            final Node node,
            final String propertyName,
            final Object initialValue,
            final String cssPropertyKey,
            final Object cssPropertyValue) {
        return config(new Configuration(node,
                                        propertyName,
                                        initialValue,
                                        cssPropertyKey,
                                        cssPropertyValue));
    }

    public static Object[] config(
            final Node node,
            final String propertyName,
            final Object initialValue,
            final String cssPropertyKey,
            final Object cssPropertyValue,
            final Object expectedFinalValue) {
        return config(new Configuration(node,
                                        propertyName,
                                        initialValue,
                                        cssPropertyKey,
                                        cssPropertyValue,
                                        expectedFinalValue));
    }

    public static Object[] config(
            final Node node,
            final String propertyName,
            final Object initialValue,
            final String cssPropertyKey,
            final Object cssPropertyValue,
            final ValueComparator comparator) {
        return config(new Configuration(node,
                                        propertyName,
                                        initialValue,
                                        cssPropertyKey,
                                        cssPropertyValue,
                                        comparator));
    }

    public static Object[] config(final Configuration configuration) {
        return new Object[] { configuration };
    }
    
    private static StyleableProperty getStyleableProperty(Node node, String cssProperty) {
        
        List<StyleableProperty> styleables = StyleableProperty.getStyleables(node);
        for(StyleableProperty styleable : styleables) {
            if (styleable.getProperty().equals(cssProperty)) {
                return styleable;
            }
        }
        fail(node.toString() + ": StyleableProperty" + cssProperty + " not found");
        return null;
    }

    public static class Configuration {
        private static final StyleConverter<String, Object> TEST_TYPE =
                StyleConverter.getInstance();

        private static final StyleableProperty UNDEFINED_KEY =
                new StyleableProperty<Node,Object>("U-N-D-E-F-I-N-E-D", TEST_TYPE, "") {

            @Override
            public boolean isSettable(Node n) {
                return false;
            }

            @Override
            public WritableValue<Object> getWritableValue(Node n) {
                return null;
            }
        };

        private final Node node;

        private final PropertyReference nodePropertyReference;

        private final Object initialValue;
        
        private final Object defaultValue;

        private final StyleableProperty cssPropertyKey;

        private final Object cssPropertyValue;

        private final Object expectedFinalValue;

        private final ValueComparator comparator;

        public Configuration(final Node node,
                             final String propertyName,
                             final Object initialValue,
                             final String cssPropertyKey,
                             final Object cssPropertyValue) {
            this(node,
                 propertyName,
                 initialValue,
                 cssPropertyKey,
                 cssPropertyValue,
                 ValueComparator.DEFAULT);
        }

        public Configuration(final Node node,
                             final String propertyName,
                             final Object initialValue,
                             final String cssPropertyKey,
                             final Object cssPropertyValue,
                             final Object finalExpectedValue) {
            this(node,
                 propertyName,
                 initialValue,
                 getStyleableProperty(node, cssPropertyKey),
                 cssPropertyValue,
                 finalExpectedValue,
                 ValueComparator.DEFAULT);
        }

        public Configuration(final Node node,
                             final String propertyName,
                             final Object initialValue,
                             final String cssPropertyKey,
                             final Object cssPropertyValue,
                             final ValueComparator comparator) {
            this(node,
                 propertyName,
                 initialValue,
                 getStyleableProperty(node, cssPropertyKey),
                 cssPropertyValue,
                 cssPropertyValue,
                 comparator);
        }

        public Configuration(final Node node,
                             final String propertyName,
                             final Object initialValue,
                             final StyleableProperty cssPropertyKey,
                             final Object cssPropertyValue,
                             final Object expectedFinalValue,
                             final ValueComparator comparator) {
            this.node = node;
            this.nodePropertyReference = 
                    PropertyReference.createForBean(node.getClass(),
                                                    propertyName);
            this.initialValue = initialValue;
            this.defaultValue = this.nodePropertyReference.getValue(this.node);
            this.cssPropertyKey = cssPropertyKey;
            this.cssPropertyValue = cssPropertyValue;
            this.expectedFinalValue = expectedFinalValue;
            this.comparator = comparator;
        }

        public void cssSettableTest() throws Exception {
            assertFalse(UNDEFINED_KEY.isSettable(node));
            assertTrue(cssPropertyKey.isSettable(node));

            final Object propertyModel = BindingHelper.getPropertyModel(
                                                 node, nodePropertyReference);
            assertTrue(cssPropertyKey.isSettable(node));

            final Class<?> typeClass = nodePropertyReference.getValueType();

            final Object variable = BindingHelper.createVariable(typeClass);
            BindingHelper.setWritableValue(typeClass, variable, initialValue);

            BindingHelper.bind(typeClass, propertyModel, variable);
            assertFalse(cssPropertyKey.isSettable(node));

            BindingHelper.unbind(typeClass, propertyModel);
            assertTrue(cssPropertyKey.isSettable(node));
        }

        public void cssSetTest() {
            nodePropertyReference.setValue(node, initialValue);
            cssPropertyKey.set(node, cssPropertyValue);

            final Object nodePropertyValue = 
                    nodePropertyReference.getValue(node);
            comparator.assertEquals(expectedFinalValue,
                                    nodePropertyValue);
        }
        
        public void cssDefaultsTest() {
            
            // is the cssInitialValue the same as the node property's default?
            final Object cssInitialValue = 
                    cssPropertyKey.getInitialValue();
            
            ValueComparator.DEFAULT.assertEquals(defaultValue, cssInitialValue);
        }
        
        public void cssPropertyReferenceIntegrityTest() {
            
            WritableValue writable = cssPropertyKey.getWritableValue(node);
            
            StyleableProperty styleable = 
                StyleableProperty.getStyleableProperty(writable);
            
            ValueComparator.DEFAULT.assertEquals(cssPropertyKey, styleable);
        }
    }
}