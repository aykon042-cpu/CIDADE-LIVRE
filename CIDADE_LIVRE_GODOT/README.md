# CIDADE LIVRE — Godot 4 foundation

This folder is an additive Godot 4 project. The original `CIDADE_LIVRE_V04.zip` at the repository root is intentionally preserved and untouched.

## Abrir o projeto
Abra esta pasta no Godot 4.3. O projeto usa o renderizador Compatibility para ampliar a compatibilidade com Android.

## Gerar APK pelo GitHub (sem computador)
1. Abra a aba **Actions** deste repositório.
2. Selecione **Build CIDADE LIVRE Android APK**.
3. Toque em **Run workflow** e confirme em **Run workflow**.
4. Aguarde o trabalho terminar com status verde.
5. Abra a execução concluída e baixe o artefato **CIDADE-LIVRE-Android-APK**.
6. Extraia o ZIP do artefato e instale o APK no Android.

O APK gerado por esse fluxo é uma compilação de depuração (debug), não uma versão assinada para publicação na Play Store. O fluxo precisa concluir com sucesso; a validação do projeto não substitui testes em aparelho real.

## Sistemas incluídos no protótipo
- Cidade procedural com ruas, prédios, calçadas, faixas e parque central.
- Personagem em terceira pessoa, corrida, salto e câmera por toque.
- Veículo dirigível com aceleração, esterçamento, freio de mão e câmera de perseguição.
- Pedestres com rotas e reação à aproximação do jogador.
- Tráfego com semáforos.
- Polícia e perseguição básica.
- HUD, dinheiro, saúde, objetivos, salvamento e estabelecimentos com interiores.

## Controles
- WASD: andar; Shift: correr/frear; Espaço: pular.
- Mouse: câmera no computador.
- Arrastar na região superior/direita: câmera no Android.
- Botões de toque: movimentação, corrida, pulo e interação.

## Estado visual e limites
O jogo ainda é um protótipo 3D low-poly com geometrias provisórias. Ainda faltam modelos finais, animações completas, áudio, combate completo, cobertura e testes extensivos de desempenho em dispositivos Android. Nenhuma imagem conceitual deve ser tratada como captura real do jogo.
