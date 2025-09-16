{...}: {
  services.gleachring = {
    enable = true;
    acme = false;
    domain = "gleach.garnix.dev";
  };

  services.nginx.virtualHosts."gleach.garnix.dev" = {
    sslCertificate = "/var/lib/acme/garnix.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/garnix.dev/key.pem";
  };
}
