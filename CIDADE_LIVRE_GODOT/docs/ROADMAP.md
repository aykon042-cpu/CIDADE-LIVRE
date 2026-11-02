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
