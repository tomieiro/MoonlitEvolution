--SETAMOS PRIMEIRAMENTE, AS VARIAVEIS IMPORTANTES QUE PODEM SER ALTERADAS DURANTE OS TESTES
TAMPOPULATION = 10
THEBESTOFTHEBEST = {-10,-10}
MELHOR = 1
POPULATION = {}
F = {}
MUTACAO = 0.002 --0.2%
TAM_AMBIENTE = 300
PONTO = {{0,0},{0,0}}
MUTACAO_VARIAVEL = true
TXMVAR = 0.0001
GERACAO = 0
MAXY= 25
RPONTOS = 3
FASTEVOLVE = 10

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
        fl.color(fl.DARK3)
        fl.rectf(10,45,(1024-15),(768-15))
        fl.push_matrix()
        fl.translate(8,200)
        fl.color(fl.BLACK)
        fl.begin_line()
        for i=0, TAM_AMBIENTE, 0.1 do
            fl.vertex(fl.transform_x(i*(TAM_AMBIENTE/(10*(TAM_AMBIENTE/100)^2)),i),420+(-fl.transform_y(Base.FxEq(i),Base.FxEq(i)*(TAM_AMBIENTE/((TAM_AMBIENTE*1.8)/MAXY)))))
        end
        fl.end_line()
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
        for i=1, TAMPOPULATION do
            fl.circle(fl.transform_x(POPULATION[i]*(TAM_AMBIENTE/(10*(TAM_AMBIENTE/100)^2)),POPULATION[i]),420+(-fl.transform_y(F[i],F[i]*(TAM_AMBIENTE/((TAM_AMBIENTE*1.8)/MAXY)))),RPONTOS)
        end
        fl.color(fl.YELLOW)
        fl.circle(fl.transform_x(THEBESTOFTHEBEST[1]*(TAM_AMBIENTE/(10*(TAM_AMBIENTE/100)^2)),THEBESTOFTHEBEST[1]),420+(-fl.transform_y(THEBESTOFTHEBEST[2],THEBESTOFTHEBEST[2]*(TAM_AMBIENTE/((TAM_AMBIENTE*1.8)/MAXY)))),RPONTOS)
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

    AutoEvolveAdj = fl.slider(1040, 155, 30, 210,"FastEvl="..FASTEVOLVE)
    AutoEvolveAdj:slider("gtk thin down box")
    AutoEvolveAdj:bounds(10,10000)
    AutoEvolveAdj:color(fl.DARK3)
    AutoEvolveAdj:type("vertical fill")
    AutoEvolveAdj:value(10000)
    AutoEvolveAdj:labelsize(8)

    PopAdj = fl.slider(1100, 155, 30, 210,"TamPop="..TAMPOPULATION)
    PopAdj:slider("gtk thin down box")
    PopAdj:bounds(10,1000)
    PopAdj:color(fl.DARK3)
    PopAdj:type("vertical fill")
    PopAdj:value(1000)
    PopAdj:labelsize(8)

    EnvAdj = fl.slider(1040, 400, 30, 210,"AmbAdj="..TAM_AMBIENTE)
    EnvAdj:slider("gtk thin down box")
    EnvAdj:bounds(10,1000)
    EnvAdj:color(fl.DARK3)
    EnvAdj:type("vertical fill")
    EnvAdj:value(1000)
    EnvAdj:labelsize(8)
    
    MutAdj = fl.slider(1100, 400, 30, 210,"TxMt="..TXMVAR)
    MutAdj:slider("gtk thin down box")
    MutAdj:bounds(0.00001,0.001)
    MutAdj:color(fl.DARK3)
    MutAdj:type("vertical fill")
    MutAdj:value(1000)
    MutAdj:labelsize(8) 

    plotaGrafico()
end

function startPop()
    GERACAO = 1
    Base.StartPopulation()
    gen:label("G: "..tostring(GERACAO))
    BESTI:label("Melhor: "..string.format("%0.6f", Base.FxEq(POPULATION[MELHOR])))
    BESTI:redraw()
    THEBEST:label("THE BEST: "..string.format("%0.6f", THEBESTOFTHEBEST[2]))
    THEBEST:redraw()
    MUT:label("Mutacao: "..string.format("%0.6f", MUTACAO))
    MUT:redraw()
    EnvAdj:label("Amb="..TAM_AMBIENTE)
    EnvAdj:redraw()
    MutAdj:label("TxMt="..string.format("%0.4f", TXMVAR))
    MutAdj:redraw()
    bEvolve:activate()
    bKill:activate()
    bAutoEvolve:activate()
    bStart:deactivate()
    PopAdj:deactivate()
    EnvAdj:deactivate()
    PONTOS:redraw()
end

function evolve()
    GERACAO = GERACAO + 1
    gen:label("G: "..tostring(GERACAO))
    Base.Evolve()
    BESTI:label("Melhor: "..string.format("%0.6f",F[MELHOR]))
    BESTI:redraw()
    THEBEST:label("THE BEST: "..string.format("%0.6f", THEBESTOFTHEBEST[2]))
    THEBEST:redraw()
    MUT:label("Mutacao: "..string.format("%0.6f", MUTACAO))
    MUT:redraw()
    PONTOS:redraw()
    janela:redraw()
end

function autoEvolve()
    for i=1, FASTEVOLVE do
        evolve()
        PONTOS:redraw()
        janela:redraw()
    end 
end

function autoEvolveAdjListener(s)
    FASTEVOLVE = 10010 - math.floor(s:value())
    s:label("FastEvl:"..FASTEVOLVE)
end

function PopAdjListener(s)
    TAMPOPULATION = 1010-math.floor(s:value())
    s:label("TamPop:"..TAMPOPULATION)
end

function EnvAdjListener(s)
    TAM_AMBIENTE = 1010-math.floor(s:value())
    s:label("Amb="..TAM_AMBIENTE)
end

function MutAdjListener(s)
    TXMVAR = s:value()
    s:label("TxMt:"..string.format("%0.6f", TXMVAR))
end

function extintionListener()
    Base.Extincao()
    janela:redraw()
    PONTOS:redraw()
end

function Main()
    instGui()
    Base.InitialEnv()
    PONTOS = plotaPontos()
    bStart:callback(startPop)
    bEvolve:callback(evolve)
    bAutoEvolve:callback(autoEvolve)
    bKill:callback(extintionListener)
    AutoEvolveAdj:callback(autoEvolveAdjListener)
    PopAdj:callback(PopAdjListener)
    MutAdj:callback(MutAdjListener)
    EnvAdj:callback(EnvAdjListener)
    janela:done()
    janela:show()
    return fl:run()
end
Main()