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

    public class MakeGameScreen: GLib.Object {

        public signal void go_menu();
        public signal void start_game(int players);

        public int players = 1;
        public int min_players = 1;
        public int max_players = 20;
        public int width;
        public int height;

        public GLib.List<Vame.Sprite> sprites;
        public GLib.List<Vame.Text> labels;

        public Vame.Text label1;
        public Vame.Text label_players;
        public Game.Button back_button;
        public Game.Button forward_button;
        public Game.Button cancel_button;
        public Game.Button ok_button;

        public MakeGameScreen() {
            this.sprites = new GLib.List<Game.Button>();
            this.labels = new GLib.List<Vame.Text>();

            this.label1 = new Vame.Text("Cantidad de jugadores");
            this.label1.font_size = 25;
            this.label1.color = { 1, 1, 1 };
            this.labels.append(this.label1);

            this.label_players = new Vame.Text(this.players.to_string());
            this.label_players.font_size = 40;
            this.label_players.color = { 1, 1, 1 };
            this.labels.append(this.label_players);

            this.back_button = new Game.Button(Utils.make_image("back.png"));
            this.back_button.sensitive = false;
            this.back_button.clicked.connect(() => { this.set_players(this.players - 1); });
            this.sprites.append(this.back_button);

            this.forward_button = new Game.Button(Utils.make_image("forward.png"));
            this.forward_button.clicked.connect(() => { this.set_players(this.players + 1); });
            this.sprites.append(forward_button);

            this.cancel_button = new Game.Button(Utils.make_image("cancel.png"));
            this.cancel_button.clicked.connect(() => { this.go_menu(); });
            this.sprites.append(this.cancel_button);

            this.ok_button = new Game.Button(Utils.make_image("play.png"));
            this.ok_button.clicked.connect(() => { this.start_game(this.players); });
            this.sprites.append(this.ok_button);
        }

        public void show(Vame.GameArea area) {
            foreach (Vame.Sprite sprite in this.sprites) {
                area.add_sprite(sprite);
            }

            foreach (Vame.Text text in this.labels) {
                area.add_text(text);
            }
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
            int spin_width = 300;
            this.width = width;
            this.height = height;

            this.label1.set_pos(width / 2 - this.label1.width / 2, this.label1.height + 5);
            this.label_players.set_pos(width / 2 - this.label_players.width / 2, this.label1.y + this.label1.height + this.back_button.image.width / 2 + 15);

            this.back_button.set_pos(width / 2 - this.back_button.image.width / 2 - spin_width / 2, this.label1.y + this.label1.height + 15);
            this.forward_button.set_pos(width / 2 - this.forward_button.image.width / 2 + spin_width / 2, this.label1.y + this.label1.height + 15);

            this.cancel_button.set_pos(10, height - this.cancel_button.image.height - 10);
            this.ok_button.set_pos(width - this.ok_button.image.width - 10, height - this.ok_button.image.height - 10);
        }

        public void set_players(int players) {
            this.players = players;
            this.label_players.text = this.players.to_string();
            this.back_button.sensitive = this.players > this.min_players;
            this.forward_button.sensitive = this.players < this.max_players;
            this.set_pos(this.width, this.height);
        }
    }
}
