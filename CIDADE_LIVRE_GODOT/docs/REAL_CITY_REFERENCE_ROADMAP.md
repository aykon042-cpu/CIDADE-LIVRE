# CIDADE LIVRE — análise de referência e plano de evolução

Data da análise: 2026-11-07

## Referência observada

A página oficial do Real City apresenta duas experiências diferentes:

- **Real City Beta:** mapa baseado no GTA V, com versões listadas para Android, iOS e Windows.
- **Capital City SAMP:** versão mais leve, baseada em SA-MP / GTA San Andreas.

A página também informa que o Real City está em beta e que recursos e regras podem mudar. Ela não publica a arquitetura interna nem confirma uso de FiveM no Android. Portanto, este documento usa apenas os recursos e a proposta observáveis como referência de produto; não presume acesso ao código ou à tecnologia interna do Real City.

Referência: https://uncountry-man.github.io/real-city/

## Estado encontrado no CIDADE LIVRE

O projeto Godot 4 já tem uma base Android separada do arquivo legado `CIDADE_LIVRE_V04.zip`, que permanece preservado. O projeto usa o renderizador Compatibility e contém:

- cidade procedural em grade, ruas, prédios, parque, calçadas e detalhes;
- personagem em terceira pessoa, corrida, salto e câmera por toque;
- veículo dirigível e câmera de perseguição;
- pedestres com rotas e reação à proximidade do jogador;
- tráfego e semáforos;
- perseguição policial básica;
- HUD, dinheiro, saúde, objetivos, salvamento;
- casas, lojas e interiores simples;
- workflow do GitHub Actions para gerar APK Android de depuração.

## Diferenças para uma experiência de RP online

Os sistemas atuais são locais e executados em uma única instância do jogo. Ainda não há evidência de:

- conexão entre vários celulares em um mesmo servidor;
- sincronização de posição, animação, veículos e estado dos jogadores;
- identidade persistente de personagem;
- economia validada no servidor;
- empregos, inventário e propriedades persistidos em banco de dados;
- voz por proximidade;
- moderação, denúncias, administração e proteção contra trapaças.

Não chamar o protótipo atual de multiplayer ou FiveM mobile até esses sistemas existirem e serem testados.

## Plano de evolução recomendado

### Fase 1 — consolidar o protótipo Android
1. Abrir e executar o projeto no Godot 4.3.
2. Rodar o workflow Android e instalar o APK em aparelho real.
3. Corrigir erros de execução e de controles por toque.
4. Medir FPS, memória e aquecimento; ajustar distância de visão, quantidade de NPCs e física.
5. Melhorar colisões, navegação e pontos de entrada/saída de veículos e interiores.

### Fase 2 — preparar multiplayer de verdade
1. Criar um gerenciador de sessão separado do mundo e do personagem local.
2. Implementar servidor autoritativo com ENetMultiplayerPeer, primeiro em rede local.
3. Replicar entrada/saída de jogadores, posição, rotação e animação com autoridade definida.
4. Sincronizar veículos e ocupantes sem permitir que cada cliente controle o estado global.
5. Testar reconexão, perda de pacote, latência e desconexão.
6. Só depois publicar servidor dedicado e cadastro persistente.

### Fase 3 — RP e persistência
1. Criar conta e personagem.
2. Salvar dinheiro, inventário, empregos, casas e veículos no servidor.
3. Validar transações e recompensas exclusivamente no servidor.
4. Criar empregos, serviços, polícia, hospital, lojas e regras de RP.
5. Adicionar ferramentas administrativas, logs e denúncias.

### Fase 4 — apresentação e conteúdo
1. Substituir geometrias provisórias por modelos próprios otimizados.
2. Adicionar animações, áudio, interiores e iluminação mais refinada.
3. Expandir a cidade por bairros, com LOD e carregamento por distância.
4. Adicionar clima, eventos e atividades sem sacrificar o desempenho Android.

## Critérios de qualidade

- Não remover nem substituir o arquivo legado.
- Não anunciar recursos que ainda não estão implementados.
- Manter o renderizador Compatibility como base inicial para Android.
- Testar em 320/360/414 px de interface e em aparelho real.
- Não aumentar a população ou a distância de visão sem medir FPS e memória.
- Fazer mudanças pequenas, revisáveis e em branch separada.
