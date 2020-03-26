Base = {}

function Base.FxEq(x,max,min)
  return (2*math.cos(0.39*x)) + (5*math.sin(0.5*x)) + (0.5*math.cos(0.1*x)) + (10*math.sin(0.7*x)) + (5*math.sin(1*x)) + (5*math.sin(0.35*x))
end

function Base.max_min()
  return 
end


function Sleep (a) 
  local sec = tonumber(os.clock() + a); 
  while (os.clock() < sec) do 
  end 
end


function Base.Avaliacao()
  for x=1, TAMPOPULATION do
    if F[x] > F[MELHOR] then MELHOR = x end
  end
  if THEBESTOFTHEBEST[2] < Base.FxEq(MELHOR) then
    THEBESTOFTHEBEST[1] = POPULATION[MELHOR]
    THEBESTOFTHEBEST[2] = Base.FxEq(MELHOR)
  end
end


function Base.StartPopulation()
  math.randomseed(os.time())
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(0, TAM_AMBIENTE)
  end
  for x=1, TAMPOPULATION do
    F[x] = Base.FxEq(POPULATION[x])
  end
  Base.Avaliacao()
end


function Base.Transa()
  for x=1, TAMPOPULATION do
      if x ~= MELHOR then
        POPULATION[x] = (POPULATION[x]+POPULATION[MELHOR])/2
      end
    local aux = (POPULATION[x] + (math.random(-TAM_AMBIENTE,TAM_AMBIENTE)*(MUTACAO)))
    if aux < TAM_AMBIENTE and aux > 0 then
      POPULATION[x] = aux
    else
      if aux > TAM_AMBIENTE then
        POPULATION[x] = (TAM_AMBIENTE-math.abs(aux-TAM_AMBIENTE))%TAMPOPULATION
      else
        POPULATION[x] = (0+math.abs(aux-TAM_AMBIENTE))%TAMPOPULATION
      end
    end
    F[x] = Base.FxEq(POPULATION[x])
  end
end

function Base.Extincao()
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(TAM_AMBIENTE)
  end
  MUTACAO = 0.02
end

--Funcao que evolui
function Base.Evolve()
  local dx = 1
  local dy = 0
  Base.Avaliacao()
  PONTO[1] = {POPULATION[MELHOR],Base.FxEq(MELHOR)}
  Base.Transa()
  if MUTACAO_VARIAVEL then
      dy = (PONTO[2][2] or 1) -(PONTO[1][2] or 1)
      dy = (PONTO[2][1] or 1) -(PONTO[1][1] or 1)
      if math.abs(dy/dx) <= TXMVAR*(MUTACAO/0.002) and math.abs(dy/dx) ~= 0 then --trancou
          MUTACAO = MUTACAO * 2
      end
      if MUTACAO < 0.000000001 or MUTACAO > 100000 then --saturacao
          Extincao()
      end
  end
  PONTO[2] = PONTO[1]
  return 
end

return Base