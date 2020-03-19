TAMPOPULATION = 100
THEBESTOFTHEBEST = {1,0}
MELHOR = 1
POPULATION = {}
F = {}
MUTACAO = 0.002 --0.2%
TAM_GRAF = 120
CSV = true
PONTO = {{0,0},{0,0}}
MUTACAO_VARIAVEL = true

function fxEq(x)
  return (2*math.cos(0.39*x)) + (5*math.sin(0.5*x)) + (0.5*math.cos(0.1*x)) + (10*math.sin(0.7*x)) + (5*math.sin(1*x)) + (5*math.sin(0.35*x))
end


function sleep (a) 
  local sec = tonumber(os.clock() + a); 
  while (os.clock() < sec) do 
  end 
end


function avaliacao()
  for x=1, TAMPOPULATION do
    if F[x] > F[MELHOR] then MELHOR = x end
  end
  if THEBESTOFTHEBEST[2] < fxEq(MELHOR) then
    THEBESTOFTHEBEST[1] = POPULATION[MELHOR]
    THEBESTOFTHEBEST[2] = fxEq(MELHOR)
  end
end


function startPopulation()
  math.randomseed(os.time())
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(0, TAM_GRAF)
  end
  for x=1, TAMPOPULATION do
    F[x] = fxEq(POPULATION[x])
  end
  avaliacao()
end


function transa()
  for x=1, TAMPOPULATION do
      if x ~= MELHOR then
        POPULATION[x] = (POPULATION[x]+POPULATION[MELHOR])/2
      end
    local aux = (POPULATION[x] + (math.random(-TAM_GRAF,TAM_GRAF)*(MUTACAO)))
    if aux < TAM_GRAF and aux > 0 then
      POPULATION[x] = aux
    else
      if aux > TAM_GRAF then
        POPULATION[x] = (TAM_GRAF-math.abs(aux-TAM_GRAF))%TAMPOPULATION
      else
        POPULATION[x] = (0+math.abs(aux-TAM_GRAF))%TAMPOPULATION
      end
    end
    F[x] = fxEq(POPULATION[x])
  end
end

function extincao()
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(TAM_GRAF)
  end
  MUTACAO = 0.02
end


function printFunction()
  local flot = require "lib.lua-flot.flot"
  local Alpha= {}
  local i = 0
  for x = 0, TAM_GRAF, 0.25 do
    Alpha[i] = {x,fxEq(x)}
    i = i+1
  end
  local p = flot.Plot {
    legend = {},
  }
  p:add_series("Alpha", Alpha)
  p:add_series('data',{x=POPULATION,y=F},{points={show=true}})
  flot.render(p,1)
end


function Main()
  local dados
  local dx = 1
  local dy = 0
  startPopulation()
  local k = 0
  if CSV then dados = io.open("dados.csv","w+") end
  if CSV then dados:write(string.format("GERACAO, PONTUACAO MELHOR INDIVIDUO\n")) end
  while k do
    sleep(1.3)
    printFunction()
    avaliacao()
    PONTO[1] = {POPULATION[MELHOR],fxEq(MELHOR)}
    transa()
    if MUTACAO_VARIAVEL then
      dy = (PONTO[2][2] or 1) -(PONTO[1][2] or 1)
      dy = (PONTO[2][1] or 1) -(PONTO[1][1] or 1)
      if math.abs(dy/dx) < 0.0000000001 and math.abs(dy/dx) ~= 0 then --trancou
        MUTACAO = MUTACAO * 1.09
      end
      if MUTACAO < 0.0000001 or MUTACAO > 1 then --saturacao
          extincao()
      end
    end
    if CSV then dados:write(string.format("%.8f,%.8f\n",k,THEBESTOFTHEBEST[2])) end
    print("POP: "..POPULATION[MELHOR], "PONT_MELHOR: "..THEBESTOFTHEBEST[2], "MUTACAO: "..MUTACAO, "DERIVADA:"..math.abs(dy/dx))
    PONTO[2] = PONTO[1]
    k = k +1
  end
  if CSV then dados:close() end
end
Main()