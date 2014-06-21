/* 
 * Copyright (c) 2011, 2014, Oracle and/or its affiliates. All rights reserved.
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

package javafx.scene.media;

/**
Builder class for javafx.scene.media.Media
@see javafx.scene.media.Media
@deprecated This class is deprecated and will be removed in the next version
* @since JavaFX 2.0
*/
@javax.annotation.Generated("Generated by javafx.builder.processor.BuilderProcessor")
@Deprecated
public final class MediaBuilder implements javafx.util.Builder<javafx.scene.media.Media> {
    protected MediaBuilder() {
    }
    
    /** Creates a new instance of MediaBuilder. */
    @SuppressWarnings({"deprecation", "rawtypes", "unchecked"})
    public static javafx.scene.media.MediaBuilder create() {
        return new javafx.scene.media.MediaBuilder();
    }
    
    private int __set;
    public void applyTo(javafx.scene.media.Media x) {
        int set = __set;
        if ((set & (1 << 0)) != 0) x.setOnError(this.onError);
        if ((set & (1 << 1)) != 0) x.getTracks().addAll(this.tracks);
    }
    
    private java.lang.Runnable onError;
    /**
    Set the value of the {@link javafx.scene.media.Media#getOnError() onError} property for the instance constructed by this builder.
    */
    public javafx.scene.media.MediaBuilder onError(java.lang.Runnable x) {
        this.onError = x;
        __set |= 1 << 0;
        return this;
    }
    
    private java.lang.String source;
    /**
    Set the value of the {@link javafx.scene.media.Media#getSource() source} property for the instance constructed by this builder.
    */
    public javafx.scene.media.MediaBuilder source(java.lang.String x) {
        this.source = x;
        return this;
    }
    
    private java.util.Collection<? extends javafx.scene.media.Track> tracks;
    /**
    Add the given items to the List of items in the {@link javafx.scene.media.Media#getTracks() tracks} property for the instance constructed by this builder.
    */
    public javafx.scene.media.MediaBuilder tracks(java.util.Collection<? extends javafx.scene.media.Track> x) {
        this.tracks = x;
        __set |= 1 << 1;
        return this;
    }
    
    /**
    Add the given items to the List of items in the {@link javafx.scene.media.Media#getTracks() tracks} property for the instance constructed by this builder.
    */
    public javafx.scene.media.MediaBuilder tracks(javafx.scene.media.Track... x) {
        return tracks(java.util.Arrays.asList(x));
    }
    
    /**
    Make an instance of {@link javafx.scene.media.Media} based on the properties set on this builder.
    */
    public javafx.scene.media.Media build() {
        javafx.scene.media.Media x = new javafx.scene.media.Media(this.source);
        applyTo(x);
        return x;
    }
}
