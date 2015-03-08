import com.sun.javafx.perf.PerformanceTracker;
import com.sun.javafx.runtime.MyProps;
import javafx.animation.Animation;
import javafx.animation.TranslateTransition;
import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.Group;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.stage.Stage;
import javafx.util.Duration;

import java.io.File;

public class mymain
{
    static
    {
//        //
//        System.setProperty("myfx.mt", "false");
////        System.setProperty("myfx.mt", "true");
//        System.setProperty("myfx.loop", "false");
////        System.setProperty("myfx.desktop", "true"); // Not used.
////        System.setProperty("myfx.tux.desktop", "true"); // Monocle/EGL. // Not used.
//
//
//        //
//        System.setProperty("javafx.platform", "Linux"); // Nor really useful?
////        System.setProperty("com.sun.javafx.isEmbedded", "true"); // :(
//
//
//        //
////        System.setProperty("javafx.embed.singleThread", "true"); // AWT/Swing.
////        System.setProperty("javafx.embed.isEventThread", "true"); // AWT/Swing.
//        System.setProperty("quantum.multithreaded", "false");
//        System.setProperty("quantum.singlethreaded", "true");
//
//
//        //
//        System.setProperty(MyProps.propid_glass_platform, "sdl");
//        // if(System.getProperty(MyProps.propid_glass_platform) == null)
//        //     if(MyProps.web)
//        //         System.setProperty(MyProps.propid_glass_platform, "sdl");
//        //     else if(MyProps.env_glass_platform != null)
//        //         System.setProperty(MyProps.propid_glass_platform, MyProps.env_glass_platform);
//        //     else
//        //         throw new RuntimeException("Can't determine '" + MyProps.propid_glass_platform + "'.");
////        System.setProperty("glass.platform", "sdl");
////        System.setProperty("glass.platform", "gtk");
////        System.setProperty("glass.platform", "Lens");
//
//
//        //
////        System.setProperty("glass.platform", "Monocle");
////        System.setProperty("embedded", "monocle");
////        System.setProperty("monocle.platform", "X11");
////        // System.setProperty("monocle.platform", "Headless");
////        System.setProperty("x11.input", "true");
////        System.setProperty("use.egl", "true");
////        System.setProperty("doNativeComposite", "true");
//
//
//        //
//        System.setProperty("prism.order", "es2");
//        System.setProperty("prism.noFallback", "true");
//
//        System.setProperty("prism.useFontConfig", "false");
//        System.setProperty("prism.embeddedfonts", "true"); // ?
////        System.setProperty("prism.fontdir", "/nonexistent/font/dir/92lbZpoChq7rlR2e/R5Lpo7oIIwx77UzN");
////        System.setProperty("prism.fontdir", "my/fonts");
//        //
////        System.setProperty("prism.dirtyopts", "false");
////        System.setProperty("prism.threadcheck", "false");
////        System.setProperty("prism.forcerepaint", "true");
////        System.setProperty("prism.scrollcacheopt", "false");
////        System.setProperty("prism.cacheshapes", "false");
//        //
////        System.setProperty("prism.showdirty", "true");
////        System.setProperty("prism.showoverdraw", "true");
////        System.setProperty("prism.printrendergraph", "true");
//
//
//        //
////        System.setProperty("javafx.debug", "true");
////        System.setProperty("javafx.verbose", "true");
////        System.setProperty("prism.verbose", "true");
////        System.setProperty("prism.trace", "true");
////        System.setProperty("prism.printStats", "1");
////        System.setProperty("prism.debugfonts", "true");
////        System.setProperty("quantum.debug", "true");
////        System.setProperty("quantum.verbose", "true");
////        System.setProperty("quantum.pulse", "true");
    }

    static void ls(String dir)
    {
        try {
            for (File f : new File(dir).listFiles()) {
                System.out.println(f.getAbsolutePath() + " " + (f.isFile() ? f.length() : ""));
                if (f.isDirectory())
                    ls(f.getAbsolutePath());
            }
        }
        catch (Exception ignored) {}
    }

    static boolean ran = false;

//    public static void tick()
//    {
////        if(ran)
////        {
////            System.out.println("-------- ls --------");
////            ls("/");
////
////            ran = false;
////        }
//
//        Application.tick();
//    }

    public static void main(String[] args) throws Exception
    {
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaBrightDemiBold.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaBrightDemiItalic.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaBrightItalic.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaBrightRegular.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaSansDemiBold.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaSansRegular.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaTypewriterBold.ttf"), 0);
//        javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/LucidaTypewriterRegular.ttf"), 0);

        Application.launch(fxapp.class, args);
    }

    public static class fxapp extends Application
    {
        @Override
        public void init() throws Exception
        {
            super.init();
        }

        @Override
        public void start(Stage primaryStage) {
//            setUserAgentStylesheet(STYLESHEET_CASPIAN);
//            setUserAgentStylesheet(STYLESHEET_MODENA);

            ran = true;

            // javafx.scene.text.Font f = javafx.scene.text.Font.loadFont(mymain.class.getResourceAsStream("/fonts/OpenSans-Regular.ttf"), 0);

            System.out.println(System.currentTimeMillis() + " fxapp.start().");

            {
                final Rectangle rect0 = new Rectangle(0, 0, 50, 50);
                rect0.setFill(Color.RED);
                final Rectangle rect1 = new Rectangle(50, 0, 50, 50);
                rect1.setFill(Color.LIME);
                final Rectangle rect2 = new Rectangle(0, 50, 50, 50);
                rect2.setFill(Color.BLUE);
                final Rectangle rect3 = new Rectangle(50, 50, 50, 50);
                rect3.setFill(Color.BLACK);
                final Group rectangles = new Group(rect0, rect1, rect2, rect3);

                final Circle circle0 = new Circle(125, 25, 25, Color.RED);
                final Circle circle1 = new Circle(175, 25, 25, Color.LIME);
                final Circle circle2 = new Circle(125, 75, 25, Color.BLUE);
                final Circle circle3 = new Circle(175, 75, 25, Color.BLACK);
                final Group circles = new Group(circle0, circle1, circle2, circle3);

                final Node movingNode = new Circle(125, 150, 25, Color.RED);
                final TranslateTransition animation = new TranslateTransition(Duration.seconds(2), movingNode);
                animation.setByX(200);
                animation.setCycleCount(Animation.INDEFINITE);
                animation.setAutoReverse(true);
                animation.play();

                final Group shapes = new Group(rectangles, circles, new Group(movingNode));

                primaryStage.setTitle("Hello World!");


                //
                Button btn = new Button();
//                HBox hbox1 = new HBox();
//                HBox hbox2 = new HBox();
//                hbox1.getChildren().add(hbox2);
//                hbox2.setAlignment(Pos.TOP_RIGHT);
//                hbox1.getChildren().add(btn);
                // btn.setFont(f);
                btn.setText("Say 'Hello World' :D");
                btn.setOnAction(event -> System.out.println("Hello World!"));
                VBox ctrl = new VBox();

                HBox fpsg = new HBox();
                CheckBox fpsc = new CheckBox("Log FPS: 0.0");
                fpsc.setSelected(true);
//                Label fps = new Label("FPS: 0.0");
//                ctrl.getChildren().add(hbox1);
                fpsg.getChildren().add(fpsc);
//                fpsg.getChildren().add(fps);
                ctrl.getChildren().add(fpsg);

                ctrl.getChildren().add(btn);
                TextField tf = new TextField();
//                tf.setFont(f);
                tf.setText("Čĉáàß§ð$€£¥‘’µ♥дерп≠×÷¹²³¤¡˝¯¸¼½¾˘«»“”´`¨¶°¿˙ˇçÇ©þ®™");
                ctrl.getChildren().add(tf);
//                fps.setAlignment(Pos.BOTTOM_RIGHT);
//                hbox1.getChildren().add(fps);


                //
                StackPane root = new StackPane();
                root.getChildren().add(shapes);
    //            root.getChildren().add(rectangles);
    //            root.getChildren().add(circles);
    //            root.getChildren().add(new Group(rectangles, circles));
    //            root.getChildren().add(movingNode);
                root.getChildren().add(ctrl);
//                root.getChildren().add(fps);
                Scene s = new Scene(root, 420, 300);
                primaryStage.setScene(s);
                primaryStage.show();

                com.sun.glass.ui.Application.GetApplication().createTimer(() ->
                {
                    float fpsv = PerformanceTracker.getSceneTracker(s).getInstantFPS();
                    fpsc.setText("Log FPS: " + fpsv);
                    if(fpsc.isSelected())
                        System.out.println("FPS: " + fpsv);
                }).start(1000);
            }

            {
//                Stage s = new Stage();
//                s.setTitle("2nd");
//                Button btn = new Button();
//                btn.setFont(f);
//                btn.setText("2nd");
//                VBox box = new VBox();
//                box.getChildren().add(btn);
//                TextField tf = new TextField();
////            root.getChildren().add(new TextField());
//                box.getChildren().add(tf);
//                s.setScene(new Scene(box, 320, 240));
//                s.show();
            }

//            System.out.println("1_____________");
//            Platform.runLater(
//                    () ->
//                    {Application.derp(); System.out.println("2_____________");});
        }
    }
}

