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

    public class PlayerSelecter: GLib.Object {

        public signal void player_selected(int player);

        public int players;
        public bool selecting = false;
        public int? selected = null;

        public GLib.Array<int> next_players;

        public Vame.Text label_title;
        public Vame.Text label_player_selected;
        public Game.Button start_button;
        public Game.Button play_button;

        public GLib.List<Vame.Sprite> sprites;
        public GLib.List<Vame.Text> labels;

        public PlayerSelecter() {
            this.sprites = new GLib.List<Vame.Sprite>();
            this.labels = new GLib.List<Vame.Text>();
            this.next_players = new GLib.Array<int>();

            this.label_title = new Vame.Text("Siguiente jugador:");
            this.label_title.font_size = 25;
            this.label_title.color = { 1, 1, 1 };
            this.labels.append(this.label_title);

            this.label_player_selected = new Vame.Text("");
            this.label_player_selected.font_size = 100;
            this.label_player_selected.color = { 1, 1, 1 };
            this.labels.append(this.label_player_selected);

            this.start_button = new Game.Button(Utils.make_image("select_player.png"));
            this.start_button.clicked.connect(() => { this.select_player(); });
            this.sprites.append(this.start_button);

            this.play_button = new Game.Button(Utils.make_image("play.png"));
            this.play_button.sensitive = false;
            this.play_button.clicked.connect(() => {
                this.player_selected(this.selected);
                this.selected = null;
            });
            this.sprites.append(this.play_button);
        }

        public void show(Vame.GameArea area) {
            foreach (Vame.Sprite sprite in this.sprites) {
                area.add_sprite(sprite);
            }

            foreach (Vame.Text text in this.labels) {
                area.add_text(text);
            }

            this.label_player_selected.text = "";
            this.start_button.sensitive = true;
            this.play_button.sensitive = false;
        }

        public void hide(Vame.GameArea area) {
            foreach (Vame.Sprite sprite in this.sprites) {
                area.remove_sprite(sprite);
            }

            foreach (Vame.Text text in this.labels) {
                area.remove_text(text);
            }
        }

        public void set_pos(int width, int height) {
            this.label_title.set_pos(width / 2 - this.label_title.width / 2, this.label_title.height + 10);
            this.label_player_selected.set_pos(width / 2 - this.label_player_selected.width / 2, height / 2 - this.label_player_selected.height / 2);

            this.start_button.set_pos(width / 2 - this.start_button.image.width / 2, this.label_player_selected.y + this.label_player_selected.height + 20);
            this.play_button.set_pos(width / 2 - this.play_button.image.width / 2, this.start_button.y + this.start_button.image.height + 20);
        }

        public void set_players(int players) {
            this.players = players;
            this.next_players = new GLib.Array<int>();  //  Remove old data

            for (int i=1; i <= this.players; i++) {
                this.next_players.append_val(i);
            }
        }

        public void select_player() {
            if (!this.selecting) {
                this.start_button.sensitive = false;
                this.play_button.sensitive = false;
                this.selected = null;

                try {
                    new GLib.Thread<int>.try("Selecting", this.select_player_thread);
                } catch (GLib.Error e) {
                    print(e.message + "\n");
                }
            }
        }

        private int select_player_thread() {
            int i = 0;
            this.selected = this.next_players.index((int)GLib.Random.int_range(1, (int32)this.next_players.length));
            int number;

            while (i < 100) {
                number = (int)GLib.Random.int_range(1, this.players);
                this.label_player_selected.text = number.to_string();
			    GLib.Thread.usleep(20000);

                i++;
            }

            this.label_player_selected.text = this.selected.to_string();
            this.start_button.sensitive = false;
            this.play_button.sensitive = true;
            return 1;
        }
    }
}
