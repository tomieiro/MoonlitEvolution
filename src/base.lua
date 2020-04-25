Base = {}

--Funcao que calcula uma funcao pre-definida
--args: (double) x
function Base.FxEq(x)
  return tonumber(string.format("%." .. PRECISION .. "f", (2*math.cos(0.39*x)) + (5*math.sin(0.5*x)) + (0.5*math.cos(0.1*x)) + (10*math.sin(0.7*x)) + (5*math.sin(1*x)) + (5*math.sin(0.35*x))))
end

--Funcao que avalia uma populacao e define o melhor e o pior
function Base.Avaliacao()
  for x=1, TAMPOPULATION do
    if F[x] > F[MELHOR] then MELHOR = x end --Se algum individuo 
    if F[x] < F[PIOR] then PIOR = x end
  end
  if THEBESTOFTHEBEST[2] < F[MELHOR] then
    THEBESTOFTHEBEST[1] = POPULATION[MELHOR]
    THEBESTOFTHEBEST[2] = F[MELHOR]
  end
end

--Funcao que inicia um ambiente para a GUI
function Base.InitialEnv()
  math.randomseed(os.time())
  for i=1, TAMPOPULATION do
    POPULATION[i] = -10
  end
  for x=1, TAMPOPULATION do
    F[x] = -10
  end
end

--Funcao que inicia uma populacao
function Base.StartPopulation()
  math.randomseed(os.time())
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(0, TAM_AMBIENTE)
  end
  for x=1, TAMPOPULATION do
    F[x] = Base.FxEq(POPULATION[x])
  end
end

--Funcao que transa um conjunto de populacao
function Base.Transa()
  for x=1, TAMPOPULATION do
    if x ~= MELHOR then
      math.randomseed(os.time())
      POPULATION[x] = (POPULATION[x] + (POPULATION[math.floor(math.random(1,TAMPOPULATION))]*((math.random(0,429))/1000.0)) + (POPULATION[MELHOR]*((math.random(0,387))/1000.0)) + (THEBESTOFTHEBEST[1]*((math.random(0,587))/1000.0)))/math.floor(math.random(1, 3))   
    end
    local aux = (POPULATION[x] + (math.random(-TAM_AMBIENTE,TAM_AMBIENTE)*(MUTACAO)))
    if aux < TAM_AMBIENTE and aux > 0 then
      POPULATION[x] = aux
    else
      if aux > TAM_AMBIENTE then
        POPULATION[x] = (TAM_AMBIENTE-math.abs(aux-TAM_AMBIENTE))%TAMPOPULATION
      else
        POPULATION[x] = (math.abs(aux-TAM_AMBIENTE))%TAMPOPULATION
      end
    end
    F[x] = Base.FxEq(POPULATION[x])
  end
end

--Funcao que extingue uma populacao
function Base.Extincao()
  Base.StartPopulation()
  MUTACAO = CONST_MUTACAO
  GERACAO = 1
end

--Funcao que preda o pior da geracao
function Base.Predacao()
  POPULATION[PIOR] = math.random(0, TAM_AMBIENTE)
  F[PIOR] = Base.FxEq(POPULATION[PIOR]);
end

--Funcao que evolui uma geracao
function Base.Evolve()
  local dx = 1
  local dy = 0
  Base.Avaliacao()
  PONTO[1] = {POPULATION[MELHOR],Base.FxEq(MELHOR)}
  Base.Transa()
  if MUTACAO_VARIAVEL then
      dy = (PONTO[2][2] or 1.0) - (PONTO[1][2] or 1.0)
      dx = (PONTO[2][1] or 1.0) - (PONTO[1][1] or 1.0)
      if math.abs(dy/dx) <= 0.02 and math.abs(dy/dx) ~= 0 then --trancou
          MUTACAO = MUTACAO * 2
      else
          MUTACAO = CONST_MUTACAO
      end
      if MUTACAO > 100 then --saturacao
          Base.Extincao()
      end
  end
  PONTO[2] = PONTO[1]
  if((GERACAO%10) == 0) then Base.Predacao() end
  return
end

return Base
