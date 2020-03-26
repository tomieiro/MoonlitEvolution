--SETAMOS PRIMEIRAMENTE, AS VARIAVEIS IMPORTANTES QUE PODEM SER ALTERADAS DURANTE OS TESTES
TAMPOPULATION = 100
THEBESTOFTHEBEST = {1,0}
MELHOR = 1
POPULATION = {}
F = {}
MUTACAO = 0.002 --0.2%
TAM_AMBIENTE = 120
PONTO = {{0,0},{0,0}}
MUTACAO_VARIAVEL = true
TXMVAR = 0.00001
GERACAO = 0

--Importando modulos
package.path = package.path..";?.o" --Dizendo que objetos ".o" tambem podem ser importados
local base = require "bin.base"
local fl = require "moonfltk"

function instGui()
    local w, h, positions
    _,_,w,h = fl.screen_xywh()
    janela = fl.double_window(math.floor(w-(w*0.88)), math.floor(h-(h*0.93)), math.floor(w*0.8), math.floor(h*0.9), "MoonlitEvolution")
    --Instanciando objetos na tela
    botoes = fl.group(5,5,math.floor(w*0.8),math.floor(h*0.9))
    botoes:insert(fl.button(10,5,140,30,"Start Population"),1)
    botoes:insert(fl.button(180,5,80,30,"Evolve"),2)
    botoes:insert(fl.button(285,5,110,30,"Kill then All!"),3)
    botoes:insert(fl.light_button(420,5,110,30,"Auto Evolve"),4)
    gen = fl.box("rshadow box",550, 5, 585, 26 ,"G: "..tostring(GERACAO))
    chart = fl.chart(65,45,(1024-15),(768-15))
    --fim
    janela:done()
    janela:show()
end

instGui()
fl:run()