{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 1514 ];
  systemd.timers."auto-create-tarefas-do-dia" = {
    watedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:00:00";
      Unit = "auto-create-tarefas-do-dia";
    };
  };

  systemd.services."auto-create-tarefas-do-dia" = {
    script = ''
      export PATH="${pkgs.coreutils}/bin:${pkgs.curl}/bin"
      curl -X POST -H "Authorization: Bearer $(cat /home/memo_token)" -H "Content-Type: application/json" -d '{"name":"atividade diárias", "state":"NORMAL", "content":"#Objetivos/Dia\n- [ ] Aguar as plantas\nvisibility: "PRIVATE"}'  https://notas.geladeira.moe/api/v1/memos
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
