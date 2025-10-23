# 🌳 Elixiraula - L-System Fractal Generator

Gerador de fractais usando L-Systems (Lindenmayer Systems) escrito em Elixir com visualização em Python/Turtle.

## 📖 Sobre

L-Systems são sistemas de reescrita paralela desenvolvidos por Aristid Lindenmayer em 1968 para modelar o crescimento de plantas. Este projeto implementa tanto sistemas determinísticos quanto estocásticos, permitindo a geração de fractais complexos como árvores, flores e curvas matemáticas.

## ✨ Funcionalidades

- **Sistemas Determinísticos**: Regras fixas que sempre produzem o mesmo resultado
- **Sistemas Estocásticos**: Regras probabilísticas para resultados variados
- **Visualização**: Geração automática de código Python/Turtle para renderização
- **Configuração Flexível**: Arquivos `.cfg` para fácil customização
- **Menu Interativo**: Interface simples para carregar e executar configurações

## 🎨 Alfabeto de Comandos

| Símbolo | Ação |
|---------|------|
| `F` | Desenhar para frente |
| `f` | Mover para frente (sem desenhar) |
| `L` | Desenhar uma folha |
| `[` | Salvar posição e ângulo |
| `]` | Restaurar posição e ângulo |
| `*` | Mudar cor |
| `+` | Virar à direita |
| `-` | Virar à esquerda |
| `X` | Não faz nada (usado no axioma) |

## 🚀 Como Usar

### Pré-requisitos

- Elixir 1.17+
- Python 3.x com turtle

### Executar

```bash
mix run run.exs
```

### Menu

```
=== L-System Generator ===
1 - Load setup.cfg
2 - Load custom file
3 - Show alphabet and examples
4 - Exit
```

## 📝 Formato do Arquivo de Configuração

Crie um arquivo `.cfg` com o seguinte formato:

### Sistema Determinístico

```
type=deterministic
axiom=X
rules=X=F+[[X]-X]-F[-FX]+X;F=FF
iterations=4
angle=25
length=10
```

### Sistema Estocástico

```
type=stochastic
axiom=X
rules=X=F-[[X]+X]+F[+FX]-X,0.6;X=F+[[X]-X]-F[-FX]+X,0.4;F=FF,1.0
iterations=4
angle=25
length=10
```

## 🌿 Exemplos

### Árvore Simples

```
type=deterministic
axiom=X
rules=X=F+[[X]-X]-F[-FX]+X;F=FF
iterations=4
angle=25
length=10
```

### Curva de Koch

```
type=deterministic
axiom=F
rules=F=F+F-F-F+F
iterations=3
angle=90
length=5
```

### Árvore Estocástica

```
type=stochastic
axiom=X
rules=X=F-[[X]+X]+F[+FX]-X,0.6;X=F+[[X]-X]-F[-FX]+X,0.4;F=FF,1.0
iterations=4
angle=25
length=10
```

## 📁 Estrutura do Projeto

```
lib/
├── sys.ex          # Implementação dos L-Systems
├── py.ex           # Geração de código Python
├── configfile.ex   # Leitura de arquivos de configuração
└── menu.ex         # Interface do menu
```

## 🔧 Módulos

- **Sys**: Funções de L-System (determinístico e estocástico)
- **Py**: Geração e execução de código Python/Turtle
- **Configfile**: Leitura e parsing de arquivos de configuração
- **Menu**: Interface de linha de comando

## 📚 Referências

- [L-Systems na Wikipedia](https://en.wikipedia.org/wiki/L-system)
- [The Algorithmic Beauty of Plants](http://algorithmicbotany.org/papers/#abop)

## 📄 Licença

MIT
