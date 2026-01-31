# Bula Digital - Painel Administrativo

Este repositório faz parte do ecossistema **Bula Digital**, um projeto desenvolvido para simplificar o acesso a informações sobre medicamentos do programa Farmácia Popular (SUS).

## 🚀 Sobre o Projeto
O **Bula Digital** não é apenas um software; é o resultado do trabalho coletivo das turmas do Curso Rackeando Pela Saúde na cidade de Ceilândia DF, dentro do projeto Incubadoras Criativas.
* **Protagonismo:** O escopo e as funcionalidades foram definidos pelos próprios alunos.
* **Desenvolvimento:** Criado durante as aulas práticas, onde os estudantes participaram ativamente da lógica, estrutura de dados e testes.
* **Contexto:** Projeto de conclusão de curso focado em aplicar a tecnologia como ferramenta de cidadania e saúde pública.

## 🏗️ Arquitetura e Compartilhamento
Para manter a paridade de dados e a eficiência do sistema, este projeto utiliza uma arquitetura de recursos compartilhados:
* **Models:** A pasta `app/models` é compartilhada via **link simbólico** entre a API e o Admin. Isso garante que qualquer regra de negócio ou alteração no banco de dados reflita instantaneamente em ambos os sistemas.
* **Storage:** O sistema de armazenamento de arquivos (bulas em PDF e anexos) também é unificado para otimizar o espaço.

## 🛠️ Tecnologias
* **Linguagem:** Ruby 3.2
* **Framework:** Ruby on Rails 8.1.1
* **Banco de Dados:** PostgreSQL
* **Infraestrutura:** Servidor Debian 12 (VPS) com Nginx e Puma.

---
*Desenvolvido pelas Turmas 1 e 2 do Curso Rackeando Pela Saúde, na cidade de Ceilândia DF - Projeto Incubadoras Criativas.*
