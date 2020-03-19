Gl = require("moongl")
Glfw = require("moonglfw")

Glfw.window_hint('context version major', 3)
Glfw.window_hint('context version minor', 3)
Glfw.window_hint('opengl profile', 'core')
Glfw.window_hint('maximized', true)

Window = Glfw.create_window(1024, 768, "MoonlitEvolution")
Glfw.make_context_current(Window)
Gl.init()

function Reshape(_, w, h) 
   Gl.viewport(0, 0, w, h)
end
Glfw.set_window_size_callback(Window, Reshape)

while not Glfw.window_should_close(Window) do
   Glfw.poll_events()
  --LETS SEE
   Gl.clear_color(0.4, 0.4, 0.4, 0.0)
   Gl.clear("color", "depth")
   Glfw.swap_buffers(Window)
end