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

    public class Button: Vame.Sprite {

        public signal void clicked();
        public signal void sensivity_changed(bool sensitive);

        public bool _sensitive = true;

        public Button(Vame.Image image) {
            base(image);

            this.mouse_in.connect(this.mouse_in_cb);
            this.mouse_out.connect(this.mouse_out_cb);
            this.click.connect(this.click_cb);
        }

        public bool sensitive {
            get { return this._sensitive; }
            set {
                this._sensitive = value;
                this.update_image();
                this.sensivity_changed(value);
            }
        }

        private void mouse_in_cb(Vame.Sprite self) {
            if (this.sensitive) {
                this.cursor_changed(Gdk.CursorType.HAND1);
            }
        }

        private void mouse_out_cb(Vame.Sprite self) {
            this.cursor_changed(Gdk.CursorType.ARROW);
        }

        private void click_cb(Vame.Sprite self) {
            if (this.sensitive) {
                this.clicked();
            }
        }

        private void update_image() {
            string current_path = this.image.path;
            string path = "";
            if (!this.sensitive && !current_path.has_suffix("_insensitive.png")) {
                path = current_path.slice(0, current_path.length - 4) + "_insensitive.png";  // ".png".length = 4
            } else if (this.sensitive && current_path.has_suffix("_insensitive.png")) {
                path = current_path.slice(0, current_path.length - 16) + ".png";  // "_insensitive.length = 16
            }

            if (path != "") {
                this.image.set_from_path(path);
            }
        }
    }

    public class TurnButton: Button {

        public TurnButton() {
            base(Utils.make_image("button.png"));
        }

        public void show(Vame.GameArea area) {
            area.add_sprite(this);
        }

        public void hide(Vame.GameArea area) {
            area.remove_sprite(this);
        }
    }

    public class MenuItem: Game.Button {

        public Vame.Text label;

        public MenuItem(string label) {
            base(Utils.make_image("menu_item.png"));

            this.label = new Vame.Text(label);
            this.label.color = { 1, 1, 1 };

            this.position_changed.connect(this.position_changed_cb);
            this.sensivity_changed.connect(this.sensivity_changed_cb);
        }

        private void position_changed_cb(Vame.Sprite self, int x, int y) {
            this.label.set_pos(x + this.image.width / 2 - this.label.width / 2, y + this.image.height / 2 + this.label.height / 2);
        }

        private void sensivity_changed_cb(Button self, bool sensitive) {
            double[] sen_color = { 1, 1, 1 };
            double[] ins_color = { 0.6, 0.6, 0.6 };
            this.label.color = sensitive? sen_color: ins_color;
        }
    }
}
