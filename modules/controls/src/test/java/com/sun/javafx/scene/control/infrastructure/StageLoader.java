/*
 * Copyright (c) 2013, Oracle and/or its affiliates. All rights reserved.
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
package com.sun.javafx.scene.control.infrastructure;

import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class StageLoader {

    private Group group;
    private Scene scene;
    private Stage stage;

    public StageLoader(Node... content) {
        if (content == null || content.length == 0) {
            throw new IllegalArgumentException("Null / empty content not allowed");
        }
        group = new Group();
        group.getChildren().setAll(content);
        scene = new Scene(group);
        stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }
    
    public StageLoader(Scene scene) {
        stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }

    // bad I know, but this is better than having unit tests running out of memory
    // and stalling. If this isn't done we leave all stages in memory as they
    // are collected in a static list (Stage.stages). The alternative is to
    // expect all users of StageLoader (i.e. ui controls unit tests) to always
    // properly clean up after themselves.
    @Override protected void finalize() throws Throwable {
        dispose();
        super.finalize();
    }

    public Stage getStage() {
        return stage;
    }
    
    public void dispose() {
        if (group != null) {
            group.getChildren().clear();
            group = null;
        }
        if (stage != null) {
            stage.hide();
            scene = null;
            stage = null;
        }
    }
}
