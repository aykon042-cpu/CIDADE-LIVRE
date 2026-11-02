# CIDADE LIVRE — Godot 4 foundation

This folder is a new, additive Godot 4 project foundation. The original `CIDADE_LIVRE_V04.zip` at the repository root is intentionally untouched.

## Open
Open this folder in Godot 4.3 or newer. The project targets the Compatibility renderer for broader Android support.

## Included prototype systems
- Procedural blockout city with roads, buildings and a central park
- Third-person character movement, sprint, jump, mouse camera and touch-drag camera on Android
- Placeholder vehicle body and basic driver control hooks
- Civilian wandering AI
- Basic police pursuit behavior
- HUD and a simple exploration/reward objective

## Visual status and limitations
The city is a procedural 3D prototype built from primitive meshes. The current visual pass adds building windows and roof trim, sidewalks, road markings, crosswalks, street lamps, park paths, trees and benches. These changes make the blockout read more like an urban environment while keeping the existing gameplay scripts and interactions.

This is still not a photorealistic GTA-style production: the player and vehicles use placeholder geometry, buildings are procedural blocks, and there are no finished character models, detailed vehicle assets, authored textures, advanced lighting, or full animation/audio pipelines. No Android APK or device-performance claim is made until the project is opened, run and tested with Godot and Android export templates.

## Controls
- WASD: move
- Shift: sprint / vehicle brake
- Space: jump
- Mouse: camera (desktop)
- Drag on the upper/right screen area: camera (Android)
- Touch buttons: move, run, jump and interact (Android)


## Distrito comercial (novo)
- Farmácia Central, Mercado Popular e Clínica Vida com interiores acessíveis.
- Use **E** perto de uma loja para entrar e novamente para comprar recuperação de saúde. Cada estabelecimento tem preço e recuperação diferentes; o saldo é validado antes da compra.
- A base continua sendo um protótipo Godot: a validação automatizada não substitui testes de gameplay em Android.


## Trânsito com semáforos
- A avenida agora tem três semáforos 3D com ciclo automático de verde, amarelo e vermelho.
- Os carros de tráfego associados à faixa reduzem e param antes do cruzamento durante o vermelho; a rota por waypoints continua ativa.


## Pedestres com rotas
- Doze pedestres circulam por três trajetos ao redor da área central, fazem pausas e retomam seus percursos.
- Ao se aproximar, o jogador assusta os pedestres; eles fogem e depois voltam para o trecho mais próximo da rota.

## Jogabilidade — atualização de movimentação e direção
- Movimento a pé relativo à câmera, aceleração e desaceleração mais suaves, controle aéreo e corrida com barra de resistência que se recupera.
- Câmera de terceira pessoa com sensibilidade ajustada para mouse e arrasto na tela.
- Direção com aceleração, esterçamento progressivo, freio de mão e câmera de perseguição que afasta conforme a velocidade.
- Ao entrar no veículo, a colisão do personagem é desativada; ao sair, é reativada para evitar que o jogador fique preso no carro.
- Os controles existentes de teclado e toque continuam usando as mesmas ações.

Ainda é uma base de jogabilidade em evolução: não inclui combate completo, sistema de cobertura, animações finais, troca de personagens ou física de veículos de produção.
