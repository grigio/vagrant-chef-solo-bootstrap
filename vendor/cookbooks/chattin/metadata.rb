maintainer       "Charles Strahan"
maintainer_email "charles.c.strahan@gmail.com"
license          "MIT"
description      "Provisions our chattin server."
long_description "Provisions our chattin server."
version          "0.0.1"

supports "ubuntu"

recipe "chattin",      "Installs basic system binaries."
recipe "chattin::god", "Installs and configures god."
