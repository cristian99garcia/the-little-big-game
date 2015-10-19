/*
Copyright (C) 2015, Cristian García <cristian99garcia@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

namespace Utils {
    static double DEGREES = 51.428571429;
    const string START_LABEL = "Nuevo juego";
    const string CONTINUE_LABEL = "Continuar juego";
    const string OPTIONS_LABEL = "Opciones";
    const string EXIT_LABEL = "Salir";

    public enum Mode {
        INIT_MENU,
        MAKING_GAME,
        PLAYING,
        ROULETTE,
        ASK_LOST_DATA,
        RESPONSES,
    }

    public enum Song {
        MENU,
        QUESTION,
        NULL,
    }

    public Vame.Image make_image(string name) {
        string path = GLib.Path.build_filename(Path.get_instance().LOCAL_PATH, @"src/images/$name");
        return new Vame.Image(path);
    }

    public Vame.Sound make_sound(string name) {
        string path = GLib.Path.build_filename(Path.get_instance().get_local_folder(), @"src/music/$name");
        return new Vame.Sound(path);
    }

    public class Path: GLib.Object {  // Singleton class

        private static Path Instance = null;

        public string LOCAL_PATH = "";

        private static void create_instance() {
            if (Instance == null) {
                Instance = new Path();
            }
        }

        public static Path get_instance() {
            if (Instance == null) {
                create_instance();
            }

            return Instance;
        }

        public void set_local_folder(string path) {
            this.LOCAL_PATH = path;
        }

        public string get_local_folder() {
            return this.LOCAL_PATH;
        }
    }
}
