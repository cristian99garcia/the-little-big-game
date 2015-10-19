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

namespace Game {

    public class Roulette: Vame.Sprite {

        public double current_rotation = 0;
        public bool rotating = false;

        public Roulette() {
            base(Utils.make_image("roulette.png"));
        }

        public void show(Vame.GameArea area) {
            area.add_sprite(this);
        }

        public void hide(Vame.GameArea area) {
            area.remove_sprite(this);
        }

        public void turn() {
            if (!this.rotating) {
                try {
                    new GLib.Thread<int>.try("Rotating", this.rotate);
                } catch (GLib.Error e) {
                    print(e.message + "\n");
                }
            }
        }

        private int rotate() {
            this.rotating = true;
            int category = (int)GLib.Random.int_range(1, 7);
            int turns = (int)GLib.Random.int_range(8, 12);
            double total_rotation = category * Utils.DEGREES + (360 * turns);
            this.current_rotation = total_rotation;

            double r = 0;
            int sleep = 300;

            while (this.current_rotation > 0) {
                if (this.current_rotation > 3600) { // three turns
                    r = 1.0;
                    sleep = 300;
                } else if (this.current_rotation > 3000) {
                    r = 0.9;
                } else if (this.current_rotation > 2600) {
                    r = 0.8;
                } else if (this.current_rotation > 2200) {
                    r = 0.7;
                    sleep = 350;
                } else if (this.current_rotation > 1700) {
                    r = 0.6;
                } else if (this.current_rotation > 1000) {
                    r = 0.5;
                } else if (this.current_rotation > 600) {
                    r = 0.4;
                    sleep = 400;
                } else if (this.current_rotation > 400) {
                    r = 0.3;
                } else if (this.current_rotation > 300) {
                    r = 0.2;
                } else if (this.current_rotation > 200) {
                    r = 0.1;
                    sleep = 500;
                } else if (this.current_rotation > 50) {
                    r = 0.05;
                    sleep = 550;
                }

                this.rotation += r;
                this.current_rotation -= r;
			    GLib.Thread.usleep(sleep);
            }

            this.current_rotation = 0;
            this.rotating = false;

            return 1;
        }
    }
}
