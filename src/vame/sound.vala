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

namespace Vame {

    public class Sound: GLib.Object {

        public signal void end();

        private dynamic Gst.Element playbin;

        public string path;
        public bool repeat { get; set; default = false; }

        public Sound(string path, bool repeat = false) {
            this.path = path;
            this.repeat = repeat;

            if (!this.path.has_prefix("file:///")) {
                this.path = "file://" + this.path;
            }
        }

        private bool bus_callback(Gst.Bus bus, Gst.Message message) {
            switch (message.type) {
                case Gst.MessageType.ERROR:
                    GLib.Error err;
                    string debug;

                    message.parse_error(out err, out debug);
                    print("Error: %s\n", err.message);
                    break;

                case Gst.MessageType.EOS:
                    if (this.repeat) {
                        this.play();
                    } else {
                        this.end();
                    }
                    break;

                case Gst.MessageType.STATE_CHANGED:
                    //Gst.State oldstate;
                    //Gst.State newstate;
                    //Gst.State pending;
                    //message.parse_state_changed(out oldstate, out newstate, out pending);
                    break;

                case Gst.MessageType.TAG:
                    break;
            }

            return true;
        }

        public void play() {
            this.playbin = Gst.ElementFactory.make("playbin", "play");
            this.playbin.uri = this.path;

            Gst.Bus bus = this.playbin.get_bus();
            bus.add_watch(bus_callback);

            this.playbin.set_state(Gst.State.PLAYING);
        }

        public void stop() {
            this.playbin.set_state(Gst.State.PAUSED);
        }
    }

    public class SoundManager: GLib.Object {

        public int MAX_SOUNDS = 8;

        public Sound? music = null;
        public GLib.List<Sound> sounds;

        public SoundManager() {
            this.sounds = new GLib.List<Sound>();
        }

        public void add_sund(Sound sound) {
            if (sounds.length() < this.MAX_SOUNDS) {
                this.sounds.append(sound);
            }
        }

        public void set_music(Sound music) {
            if (this.music != null) {
                this.music.stop();
            }

            this.music = music;
            this.music.play();
        }
    }
}
