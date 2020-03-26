--SETAMOS PRIMEIRAMENTE, AS VARIAVEIS IMPORTANTES QUE PODEM SER ALTERADAS DURANTE OS TESTES
TAMPOPULATION = 200
THEBESTOFTHEBEST = {1,0}
MELHOR = 1
POPULATION = {}
F = {}
MUTACAO = 0.002 --0.2%
TAM_AMBIENTE = 200
PONTO = {{0,0},{0,0}}
MUTACAO_VARIAVEL = true
TXMVAR = 0.00001
GERACAO = 0
MAXY= 25
RPONTOS = 3
FASTEVOLVE = 100

--OBJETOS DA GUI
PONTOS = nil

--Importando modulos
package.path = package.path..";?.o" --Dizendo que objetos ".o" tambem podem ser importados
local base = require "bin.base"
local fl = require "moonfltk"


function plotaGrafico()
    local self = fl.widget_sub(10,45,(1024-15),(768-15))
    self:override_draw(function()
        fl.push_clip(10,45,(1024-15),(768-15))
        fl.color(fl.DARK2)
        fl.rectf(10,45,(1024-15),(768-15))
        fl.push_matrix()
        fl.translate(8,200)
        fl.color(fl.BLACK)
        fl.begin_line()
        for i=0, TAM_AMBIENTE, 0.1 do
            fl.vertex(fl.transform_x(i*(TAM_AMBIENTE/(10*(TAM_AMBIENTE/100)^2)),i),420+(-fl.transform_y(Base.FxEq(i),Base.FxEq(i)*(TAM_AMBIENTE/((TAM_AMBIENTE*1.8)/MAXY)))))
        end
        fl.end_line()
        fl.begin_line()
        fl.pop_matrix()
        fl.pop_clip()
    end)
    return self
end

function plotaPontos()
    local self = fl.widget_sub(10,45,(1024-15),(768-15))
    self:override_draw(function()
        fl.push_clip(10,45,(1024-15),(768-15))
        fl.push_matrix()
        fl.translate(8,200)
        fl.color(fl.RED)
        fl.begin_points()
        for i=1, TAMPOPULATION do
            fl.circle(fl.transform_x(POPULATION[i]*(TAM_AMBIENTE/(10*(TAM_AMBIENTE/100)^2)),POPULATION[i]),420+(-fl.transform_y(F[i],F[i]*(TAM_AMBIENTE/((TAM_AMBIENTE*1.8)/MAXY)))),RPONTOS)
        end
        fl.end_points()
        fl.begin_line()
        fl.pop_matrix()
        fl.pop_clip()
    end)
    return self
end

function instGui()
    local w, h, positions
    _,_,w,h = fl.screen_xywh()
    janela = fl.double_window(math.floor(w-(w*0.88)), math.floor(h-(h*0.93)), math.floor(w*0.8), math.floor(h*0.9), "MoonlitEvolution")
    --Instanciando objetos na tela
    botoes = fl.group(5,5,math.floor(w*0.8),math.floor(h*0.9))
    bStart = fl.button(10,5,140,30,"Start Population")
    bEvolve = fl.button(180,5,80,30,"Evolve")
    bKill = fl.button(285,5,110,30,"Kill then All!")
    bAutoEvolve = fl.button(420,5,110,30,"Auto Evolve")
    bEvolve:deactivate()
    bKill:deactivate()
    bAutoEvolve:deactivate()
    botoes:insert(bStart,1)
    botoes:insert(bEvolve,2)
    botoes:insert(bKill,3)
    botoes:insert(bAutoEvolve,4)
    gen = fl.box("rshadow box",550, 5, 585, 26 ,"G: "..tostring(GERACAO))
    
    BESTI = fl.box("rshadow box",1030, 45, 110, 30 ,"Melhor: ".."None")
    BESTI:labelsize(10)

    THEBEST = fl.box("rshadow box",1030, 80, 110, 30 ,"THE BEST: ".."None")
    THEBEST:labelsize(10)
   
    MUT = fl.box("rshadow box",1030, 115, 110, 30 ,"Mutacao: ".."None")
    MUT:labelsize(10)

    MutAdj = fl.slider(1040, 155, 30, 210,"AutoGen="..FASTEVOLVE)
    MutAdj:slider("gtk thin down box")
    MutAdj:bounds(10,10000)
    MutAdj:color(fl.DARK3)
    MutAdj:type("vertical fill")
    MutAdj:value(10000)
    MutAdj:labelsize(8)

    PopAdj = fl.slider(1100, 155, 30, 210,"TamPop="..TAMPOPULATION)
    PopAdj:slider("gtk thin down box")
    PopAdj:bounds(1,1000)
    PopAdj:color(fl.DARK3)
    PopAdj:type("vertical fill")
    PopAdj:value(1000)
    PopAdj:labelsize(8)
    
    plotaGrafico()
end

function startPop()
    GERACAO = 1
    Base.StartPopulation()
    gen:label("G: "..tostring(GERACAO))
    gen:redraw()
    PONTOS:redraw()
    BESTI:label("Melhor: "..string.format("%0.6f", Base.FxEq(POPULATION[MELHOR])))
    BESTI:redraw()
    THEBEST:label("THE BEST: "..string.format("%0.6f", THEBESTOFTHEBEST[2]))
    THEBEST:redraw()
    MUT:label("Mutacao: "..string.format("%0.6f", MUTACAO))
    MUT:redraw()
    bEvolve:activate()
    bKill:activate()
    bAutoEvolve:activate()
    bStart:deactivate()
    PopAdj:deactivate()
end

function evolve()
    GERACAO = GERACAO + 1
    gen:label("G: "..tostring(GERACAO))
    gen:redraw()
    Base.Evolve()
    PONTOS:redraw()
    BESTI:label("Melhor: "..string.format("%0.6f",F[MELHOR]))
    BESTI:redraw()
    THEBEST:label("THE BEST: "..string.format("%0.6f", THEBESTOFTHEBEST[2]))
    THEBEST:redraw()
    MUT:label("Mutacao: "..string.format("%0.6f", MUTACAO))
    MUT:redraw()
end

function autoEvolve()
    for i=1, FASTEVOLVE do
        evolve()
    end
end

function autoEvolveAdjListener(s)
    FASTEVOLVE = math.floor(s:value())
    s:label("FastEvl:"..FASTEVOLVE)
end


instGui()
Base.InitialEnv()
PONTOS = plotaPontos()
bStart:callback(startPop)
bEvolve:callback(evolve)
bAutoEvolve:callback(autoEvolve)
bKill:callback(Base.Extincao)
MutAdj:callback(autoEvolveAdjListener)
janela:done()
janela:show()
return fl:run()
--fl.unreference(PONTOS)