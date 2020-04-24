<h1>MoonlitEvolution</h1>
<h3>Projeto de algoritmos evolutivos usando Lua</h3>

**Este projeto tem por objetivo aplicar -através da linguagem Lua-, com fim de ilustrar, algoritmos evolutivos com uma simples interface,utilizando FLTK.**

<h5>ANTES DE COMEÇAR A UTILIZAR:</h5>

<p><em><strong>(PASSO 1)</strong></em></p>
Inicialmente, algumas libs são necessárias: liblua5.3-dev(https://www.lua.org/), libfltk1.3-dev(https://www.fltk.org/) e os próprios binarios de lua(https://www.lua.org/). Para instalá-las, se estiver no Linux, use: **make INSTALL_COMPONENTS**. 


<p><em><strong>(PASSO 2)</strong></em></p>
Para a GUI em Lua, utilizei a lib: MoonFLTK(https://github.com/stetre/moonfltk). Acesse o link da moonfltk, citado acima, para instalar o módulo. O passo-a-passo está na página do repositorio "moonfltk" e ele não possui depencias externas fora as já instaladas pelo **make INSTALL_COMPONENTS**.


<h5>COMO COMEÇAR A UTILIZAR:</h5>

Para rodar o projeto, utilize o comando: **make all*** ou simplesmente **make**
Para limpar o binários gerados: **make clean**
