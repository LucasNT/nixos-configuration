{ config, lib, pkgs, ... }:

{
  systemd.timers."auto-create-tarefas-do-dia" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:00:00";
      Unit = "auto-create-tarefas-do-dia";
    };
  };

  systemd.services."auto-create-tarefas-do-dia" = {
    script = ''
      export PATH="${pkgs.coreutils}/bin:${pkgs.curl}/bin"
      curl -X POST -H "Authorization: Bearer $(cat /home/memo_token)" -H "Content-Type: application/json" -d '{"name":"atividade diárias", "state":"NORMAL", "content":"#Objetivos/Dia\n- [ ] Aguar as plantas\n- [ ] Termo\n-[ ] Dueto\n-[ ] Quarteto\n- [ ] Xadrez\n- [ ] Opacha MD\n", visibility: "PRIVATE"}'  https://notas.geladeira.moe/api/v1/memos
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
