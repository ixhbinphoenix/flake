{pkgs, inputs, ...}: {
  services.nginx.virtualHosts."garnix.dev" = {
    onlySSL = true;
    sslCertificate = "/var/lib/acme/garnix.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/garnix.dev/key.pem";

    root = inputs.garnix-dev.packages.${pkgs.system}.default;

    locations."/" = {
      index = "index.html";
      tryFiles = "$uri $uri.html $uri/ $uri/index.html =404";
    };
  };
}
