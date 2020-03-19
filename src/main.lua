local base = loadfile("base.bin")
local dados
local dx = 1
local dy = 0
StartPopulation()
local k = 0
while k do
    Sleep(1.3)
    base.PrintFunction()
    base.Avaliacao()
    PONTO[1] = {POPULATION[MELHOR],FxEq(MELHOR)}
    Transa()
    if MUTACAO_VARIAVEL then
    dy = (PONTO[2][2] or 1) -(PONTO[1][2] or 1)
    dy = (PONTO[2][1] or 1) -(PONTO[1][1] or 1)
    if math.abs(dy/dx) < 0.0000000001 and math.abs(dy/dx) ~= 0 then --trancou
        MUTACAO = MUTACAO * 1.09
    end
    if MUTACAO < 0.0000001 or MUTACAO > 1 then --saturacao
        Extincao()
    end
    end
    PONTO[2] = PONTO[1]
    k = k +1
end