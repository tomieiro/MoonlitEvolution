--SETAMOS PRIMEIRAMENTE, AS VARIAVEIS IMPORTANTES QUE PODEM SER ALTERADAS DURANTE OS TESTES
TAMPOPULATION = 10
THEBESTOFTHEBEST = {-10,-10}
MELHOR = 1
PIOR = 1
POPULATION = {}
F = {}
CONST_MUTACAO = 0.002
MUTACAO = CONST_MUTACAO
TAM_AMBIENTE = 300
PONTO = {{0,0},{0,0}}
MUTACAO_VARIAVEL = true
--TXMVAR = 0.0001
GERACAO = 0
MAXY= 25
RPONTOS = 2
FASTEVOLVE = 10
PRECISION = 6

--OBJETOS DA GUI
PONTOS = nil

--Importando modulos
package.path = package.path..";?.o" --Dizendo que objetos ".o" tambem podem ser importados
local base = require "bin.base"
local fl = require "moonfltk"

--Funcao que plota o grafico na tela
function plotaGrafico()
    local self = fl.widget_sub(10,45,(800-15),(600-15))
    self:override_draw(function()
        fl.push_clip(10,45,(550-15),(500-15))
        fl.color(fl.DARK3)
        fl.rectf(10,45,(800-15),(600-15))
        fl.push_matrix()
        fl.translate(8,200)
        fl.color(fl.BLACK)
        fl.begin_line()
        for i=0, TAM_AMBIENTE, 0.1 do
            fl.vertex(fl.transform_x(i*(TAM_AMBIENTE/(19*(TAM_AMBIENTE/100)^2)),i),295+(-fl.transform_y(Base.FxEq(i),Base.FxEq(i)*(TAM_AMBIENTE/((TAM_AMBIENTE*2.8)/MAXY)))))
        end
        fl.end_line()
        fl.pop_matrix()
        fl.pop_clip()
    end)
    return self
end

--Funcao que plota os pontos no grafico
function plotaPontos()
    local self = fl.widget_sub(10,45,(800-15),(600-15))
    self:override_draw(function()
        fl.push_clip(10,45,(800-15),(600-15))
        fl.push_matrix()
        fl.translate(8,200)
        fl.color(fl.RED)
        for i=1, TAMPOPULATION do
            fl.circle(fl.transform_x(POPULATION[i]*(TAM_AMBIENTE/(19*(TAM_AMBIENTE/100)^2)),POPULATION[i]),295+(-fl.transform_y(F[i],F[i]*(TAM_AMBIENTE/((TAM_AMBIENTE*2.8)/MAXY)))),RPONTOS)
        end
        fl.color(fl.YELLOW)
        fl.circle(fl.transform_x(THEBESTOFTHEBEST[1]*(TAM_AMBIENTE/(19*(TAM_AMBIENTE/100)^2)),THEBESTOFTHEBEST[1]),295+(-fl.transform_y(THEBESTOFTHEBEST[2],THEBESTOFTHEBEST[2]*(TAM_AMBIENTE/((TAM_AMBIENTE*2.8)/MAXY)))),RPONTOS)
        fl.pop_matrix()
        fl.pop_clip()
    end)
    return self
end

--Funcao que instancia a gui, com seus botoes, sliders e grafico
function instGui()
    local w, h, positions
    w,h = 800,600
    --Instanciando objetos na tela
    botoes = fl.group(5,5,math.floor(w*0.8),math.floor(h*0.9))
    bStart = fl.button(10,5,70,30,"Start")
    bEvolve = fl.button(90,5,80,30,"Evolve")
    bKill = fl.button(180,5,100,30,"Genocide!")
    bAutoEvolve = fl.button(290,5,110,30,"Auto Evolve")
    bEvolve:deactivate()
    bKill:deactivate()
    bAutoEvolve:deactivate()
    botoes:insert(bStart,1)
    botoes:insert(bEvolve,2)
    botoes:insert(bKill,3)
    botoes:insert(bAutoEvolve,4)

    gen = fl.box("rshadow box",410, 5, 180, 26 ,"G: "..tostring(GERACAO))
    
    BESTI = fl.box("rshadow box",550, 45, 80, 30 ,"Melhor: ".."None")
    BESTI:labelsize(8)

    THEBEST = fl.box("rshadow box",550, 80, 80, 30 ,"THE BEST: ".."None")
    THEBEST:labelsize(8)
   
    MUT = fl.box("rshadow box",550, 115, 80, 30 ,"Mutacao: ".."None")
    MUT:labelsize(8)

    AutoEvolveAdj = fl.slider(580, 180, 30, 310,"AUTO_GER="..FASTEVOLVE)
    AutoEvolveAdj:slider("gtk thin down box")
    AutoEvolveAdj:bounds(10,10000)
    AutoEvolveAdj:color(fl.DARK3)
    AutoEvolveAdj:type("vertical fill")
    AutoEvolveAdj:value(10)
    AutoEvolveAdj:labelsize(10)

    janela:insert(botoes,1)
    plotaGrafico()
end

--Funcao que seta parametros iniciais nos elementos na gui
function startPop()
    GERACAO = 1
    Base.StartPopulation()
    gen:label("G: "..tostring(GERACAO))
    BESTI:label("Melhor: "..string.format("%0.4f", Base.FxEq(POPULATION[MELHOR])))
    BESTI:redraw()
    THEBEST:label("THE BEST: "..string.format("%0.4f", THEBESTOFTHEBEST[2]))
    THEBEST:redraw()
    MUT:label("Mutacao: "..string.format("%0.4f", MUTACAO))
    MUT:redraw()
    bEvolve:activate()
    bKill:activate()
    bAutoEvolve:activate()
    bStart:deactivate()
    PONTOS:redraw()
end

--Funcao que altera os valores dos elementos apos a evolucao e desenha os novos pontos
function evolve()
    GERACAO = GERACAO + 1
    gen:label("G: "..tostring(GERACAO))
    Base.Evolve()
    BESTI:label("Melhor: "..string.format("%0.4f",F[MELHOR]))
    BESTI:redraw()
    THEBEST:label("THE BEST: "..string.format("%0.4f", THEBESTOFTHEBEST[2]))
    THEBEST:redraw()
    MUT:label("Mutacao: "..string.format("%0.4f", MUTACAO))
    MUT:redraw()
    PONTOS:redraw()
    janela:redraw()
end

--Listeners dos botoes da gui

function autoEvolve()
    for i=1, FASTEVOLVE do
        evolve()
        PONTOS:redraw()
        janela:redraw()
    end 
end

function autoEvolveAdjListener(s)
    FASTEVOLVE = math.floor(s:value())
    s:label("AUTO_GER="..FASTEVOLVE)
end

function PopAdjListener(s)
    TAMPOPULATION = math.floor(s:value())
    s:label("TamPop:"..TAMPOPULATION)
end

function extintionListener()
    Base.Extincao()
    janela:redraw()
    PONTOS:redraw()
end


--Funcao que confirma parametros na tela inicial
function confirmaParametrosManual(s)
    TAMPOPULATION = tonumber(popValue:value())
    TAM_AMBIENTE = tonumber(EnvValue:value())
    CONST_MUTACAO =  tonumber(MutValue:value())
    MUTACAO = CONST_MUTACAO
    MutValue:hide()
    confirmaPop:deactivate()
    confirmaPop:hide()
    texto:deactivate()
    texto:hide()
    popValue:deactivate()
    popValue:hide()
    EnvValue:deactivate()
    EnvValue:hide()
    bAuto:hide()
    instGui()
    Base.InitialEnv()
    PONTOS = plotaPontos()
    bStart:callback(startPop)
    bEvolve:callback(evolve)
    bAutoEvolve:callback(autoEvolve)
    bKill:callback(extintionListener)
    AutoEvolveAdj:callback(autoEvolveAdjListener)
    janela:redraw()
end

function confirmaParametrosAutomatico()
    confirmaParametrosManual(confirmaPop)
    bStart:hide()
    bEvolve:hide()
    bAutoEvolve:hide()
    bKill:activate()
    AutoEvolveAdj:hide()
    timer = fl.set_timeout(0.1,true,evolve)
end

function ok()
    if(popValue:value() == "" or EnvValue:value() == "" or MutValue:value() == "") then return end;
    if(auto) then
        confirmaParametrosAutomatico()
    else
        confirmaParametrosManual()
    end
end

function bAutoC(s)    
    if(s:value()) then
        auto = s:value()
    else
        auto = false
    end
end

---



--Funcao main; instacia roda a aplicacao
function Main()
    local w, h, positions
    local auto = false
    w,h = 800,600
    janela = fl.double_window(math.floor(w-(w*0.88)), math.floor(h-(h*0.93)), math.floor(w*0.8), math.floor(h*0.9), "MoonlitEvolution")
    texto = fl.box(280, 170, 60, 30, "DIGITE OS PARAMETROS\n\n\n")
    popValue = fl.int_input(280, 200, 60, 40, "TAM POPULACAO  ")
    EnvValue = fl.int_input(280, 250, 60, 40, "TAM AMBIENTE   ")
    MutValue = fl.float_input(280, 300, 60, 40, "TX MUTACAO     ")
    confirmaPop = fl.button(390, 250, 60, 40, "OK")
    bAuto = fl.toggle_button(270, 360, 80, 30, "Automatico")
    bAuto:callback(bAutoC)
    confirmaPop:callback(ok)
    janela:done()
    janela:show()
    return fl:run()
end
Main()
