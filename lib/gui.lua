gl = require("moongl")
glfw = require("moonglfw")

glfw.window_hint('context version major', 3)
glfw.window_hint('context version minor', 3)
glfw.window_hint('opengl profile', 'core')
glfw.window_hint('maximized', true)

window = glfw.create_window(1024, 768, "MoonlitEvolution")
glfw.make_context_current(window)
gl.init()

function reshape(_, w, h) 
   gl.viewport(0, 0, w, h)
end
glfw.set_window_size_callback(window, reshape)

while not glfw.window_should_close(window) do
   glfw.poll_events()
  --LETS SEE
   gl.clear_color(0.4, 0.4, 0.4, 0.0)
   gl.clear("color", "depth")
end
