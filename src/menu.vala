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

    public class Menu {

        public signal void play();
        public signal void continue_game();
        public signal void options();
        public signal void exit();

        public GLib.List<Game.MenuItem> items;
        public GLib.List<Vame.Text> labels;

        public Menu() {
            this.items = new GLib.List<Game.MenuItem>();
            this.labels = new GLib.List<Vame.Text>();

            string[] list = {Utils.START_LABEL, Utils.CONTINUE_LABEL, Utils.OPTIONS_LABEL, Utils.EXIT_LABEL};
            foreach (string a in list) {
                Game.MenuItem item = new Game.MenuItem(a);
                item.sensitive = a != Utils.CONTINUE_LABEL;
                item.clicked.connect(this.item_selected);
                this.items.append(item);
                this.labels.append(item.label);
            }
        }

        public void show(Vame.GameArea area) {
            foreach (Game.MenuItem item in this.items) {
                item.sensitive = item.label.text != Utils.CONTINUE_LABEL;
                area.add_sprite(item);
            }

            foreach (Vame.Text text in this.labels) {
                area.add_text(text);
            }
        }

        public void hide(Vame.GameArea area) {
            foreach (Game.MenuItem item in this.items) {
                area.remove_sprite(item);
            }

            foreach (Vame.Text text in this.labels) {
                area.remove_text(text);
            }
        }

        public void set_pos(int x, int y) {
            int? _y = null;
            foreach (Game.MenuItem item in this.items) {
                if (_y == null) {
                    _y = ((item.image.height + 10) * (int)this.items.length()) / 2;
                }

                item.set_pos(x - item.image.width / 2, _y);
                _y += item.image.height + 5;
            }
        }

        private void item_selected(Game.Button button) {
            Game.MenuItem item = (button as Game.MenuItem);
            switch (item.label.text) {
                case Utils.START_LABEL:
                    this.play();
                    break;

                case Utils.CONTINUE_LABEL:
                    this.continue_game();
                    break;

                case Utils.OPTIONS_LABEL:
                    this.options();
                    break;

                case Utils.EXIT_LABEL:
                    this.exit();
                    break;
            }
        }
    }
}
