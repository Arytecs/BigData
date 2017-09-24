# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.define "sl1" do |sl1|

#     sl1.vm.network "private_network", ip: "XX.XX.XX.XX", auto_config: true

     sl1.vm.provider "virtualbox" do |v|
        v.name = "ipa-sl1"
	# Memoria: 1024
	# Núcleos: 2
     end

     sl1.vm.provision "network-config", type: "shell" do |s|
	     # Configuración de red del servidor
	     # argumentos?? 
     end

     sl1.vm.provision "ipa-server-install", type: "shell" do |s|
	     # Instalación del servidor IPA
	     # argumentos??
     end
     sl1.vm.provision "ipa-server-addusers", type: "shell" do |s|
	     # Añadir usuarios al servidor IPA 
	     # argumentos??
     end
  end	


  # SOLUCION BASICA: Configurar un único cliente "cl1"
  # MEJORA: Hacer un bucle de 1 a MAX_CLIENTS para configurar varios clientes

    config.vm.define "cl1" do |cli|
#       cli.vm.network "private_network", ip: "XX.XX.XX.XX", auto_config: true

       cli.vm.provider "virtualbox" do |v|
          v.name = "ipa-cl1"
	  # Memoria: 512
	  # Núcleos: 1
       end

       cli.vm.provision "network-config", type: "shell" do |s|
	        # Configuración de red del cliente 
		# (mismo script que en el servidor, pero distintos argumentos!!)
       end
       cli.vm.provision "ipa-client-install", type: "shell" do |s|
	       # Instalación del cliente IPA
       end
    end
  end	
end

