TAMPOPULATION = 100
THEBESTOFTHEBEST = {1,0}
MELHOR = 1
POPULATION = {}
F = {}
MUTACAO = 0.002 --0.2%
TAM_AMBIENTE = 120
PONTO = {{0,0},{0,0}}
MUTACAO_VARIAVEL = true

function FxEq(x)
  return (2*math.cos(0.39*x)) + (5*math.sin(0.5*x)) + (0.5*math.cos(0.1*x)) + (10*math.sin(0.7*x)) + (5*math.sin(1*x)) + (5*math.sin(0.35*x))
end


function Sleep (a) 
  local sec = tonumber(os.clock() + a); 
  while (os.clock() < sec) do 
  end 
end


function Avaliacao()
  for x=1, TAMPOPULATION do
    if F[x] > F[MELHOR] then MELHOR = x end
  end
  if THEBESTOFTHEBEST[2] < FxEq(MELHOR) then
    THEBESTOFTHEBEST[1] = POPULATION[MELHOR]
    THEBESTOFTHEBEST[2] = FxEq(MELHOR)
  end
end


function StartPopulation()
  math.randomseed(os.time())
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(0, TAM_AMBIENTE)
  end
  for x=1, TAMPOPULATION do
    F[x] = FxEq(POPULATION[x])
  end
  Avaliacao()
end


function Transa()
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
    F[x] = FxEq(POPULATION[x])
  end
end

function Extincao()
  for i=1, TAMPOPULATION do
    POPULATION[i] = math.random(TAM_AMBIENTE)
  end
  MUTACAO = 0.02
end