# CIDADE LIVRE — desenvolvimento por etapas

## Base criada
- Projeto Godot 4 com renderer Compatibility.
- Cidade procedural de blockout, personagem, veículo placeholder, pedestres e policial.
- HUD e objetivo simples.
- Workflow de validação headless.

## Sistemas adicionados nesta etapa
- Câmera por arrasto na tela para Android, mantendo a área esquerda para movimento e o canto inferior direito para ações.
- Sensibilidade de câmera touch configurável separadamente da sensibilidade do mouse.
- Controles touch sintetizando ações do InputMap.
- Gerenciador de save JSON versionado.
- Gerenciador de missões com sinalização e recompensas.
- Base de veículo de tráfego com waypoints e parada por semáforo.

## Próximas etapas prioritárias
1. Integrar e validar scripts na cena principal.
2. Implementar interação real de entrar/sair do carro e troca de câmera.
3. Implementar navegação de pedestres e veículos com NavigationServer3D/waypoints por faixa.
4. Adicionar ciclo dia/noite, clima e persistência completa do mundo.
5. Implementar combate, inventário, lojas, interiores e progressão.
6. Substituir placeholders por modelos, animações, áudio e assets originais.
7. Perfil de desempenho e exportação em dispositivos Android reais.

## Critério de qualidade
Cada sistema precisa ser integrado à cena, executado no Godot e testado antes de ser marcado como concluído. A existência de um script isolado não significa que a funcionalidade esteja pronta.

## Marco residencial — seis casas com identidade própria
- Seis casas posicionadas dentro dos quarteirões, fora das faixas de tráfego.
- Cada casa recebe uma paleta própria para fachada, telhado, paredes internas, piso e mobiliário.
- Interiores mobiliados com colisões, iluminação quente e entrada/saída pelo sistema de interação.
- Colisões dos ambientes são alternadas ao entrar e sair para evitar paredes invisíveis bloqueando o jogador.
- A validação automatizada confirma importação e inicialização headless; ainda falta teste de colisão e desempenho em Android real.


## Marco comercial — distrito de serviços interativos
- Três estabelecimentos posicionados em quarteirões reservados: Farmácia Central, Mercado Popular e Clínica Vida.
- Fachadas com identidade visual, entradas acessíveis e interiores com balcão, prateleira e iluminação.
- Interação por proximidade: primeira ação entra; segunda compra recuperação de saúde, com preço e quantidade próprios por loja.
- Compra valida saldo, impede gasto quando a saúde já está cheia e atualiza o dinheiro e a barra de vida existentes.
- A validação headless verifica importação e inicialização; ainda falta teste manual de navegação, colisões e compra no Android.


## Marco de trânsito — semáforos funcionais
- Três semáforos 3D com luzes vermelha, amarela e verde visíveis no cruzamento da avenida.
- Ciclo temporizado: verde, amarelo e vermelho, com duração configurável por instância.
- Veículos de tráfego recebem uma referência ao semáforo da sua faixa e freiam quando chegam à zona de parada durante o vermelho.
- O sistema preserva os waypoints e a condução existentes; ainda requer teste visual e físico no Godot/Android para ajustar distâncias e frenagem.


## Marco de população — rotas de pedestres
- Doze civis distribuídos em três circuitos de caminhada ao redor da área central, em vez de destinos totalmente aleatórios.
- Cada civil percorre pontos de rota em sequência, faz pequenas pausas e retoma o circuito.
- Ao perceber o jogador próximo, o pedestre foge temporariamente; depois retorna ao ponto mais próximo de sua rota.
- Mantidos gravidade, colisão e movimento via CharacterBody3D; ainda é necessário observar cruzamentos e evitar obstáculos no teste de gameplay.
