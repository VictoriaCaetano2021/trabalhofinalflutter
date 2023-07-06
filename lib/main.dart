
// Criar um aplicativo que :
// ok // Proporcione o acesso do usuário ao sistema mediante login
// ok // O sistema deve permitir o cadastro de novos usuarios 
// ok // Permita que este faça o cadastro e manutenção de dados (uma única tabela - dados a escolha do aluno) --> criei um bloco de notas, te metÊÊÊ
// ok // Montar uma página que liste os itens cadastrados e permita que este selecione itens a serem excluídos. Promporcionando a exclusão quando solicitado pelo usuário. --> gastei tempo fazendo editar e nem precisava kakaakkak credo, tenho que ler as descrições antes
// ok // Utilizar o banco de dados oferecido pela instituição (Banco postgres)
// ok // Atenção para a data de entrega - 27/06 até as 19:00
// -- // Serão consideradas a qualidade das telas, modularização (componentização), clareza do código

import 'package:flutter/material.dart';

import 'banco/banco.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App - Trabalho de PDM',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.book, size: 100.0, color: Colors.lightGreen),
                  SizedBox(height: 16.0),
                  Text(
                    'Bloco de Notas',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
      drawer: Drawer(
        child: ListView(
          children: [
            
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Novo Usuário'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NovoUsuarioPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  //isso ta certo? credo
  //porque não funciona a entrada de texto?? sera que é a IDE online que faz isso??
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  
  var banco;

  @override
  Widget build(BuildContext context) {
     banco = Banco(falhaConexao);
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                executa(context);
               },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  executa(BuildContext context) async {
    // String comando = "select id_user from tb_user where login_user='victoria' and login_pass='123'";
    String login = _loginController.text;
    String pass = _passwordController.text;
    String comando = "select id_user from tb_user where login_user='$login' and login_pass='$pass'";

    print(comando);
    // await banco?.query(comando, imprime, falhaConexao);

    await banco?.query(comando, (num_registros, result) {

          print(result);
          if(result!.length == 1){
          final primeiroRegistro = result![0];
        
          // Acessa o valor do campo "id_user"
          final userId = primeiroRegistro["tb_user"]["id_user"];
          print(userId);

            // Redirecionar para a página desejada
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaginaUsuario(
                  login: login,
                  senha: pass,
                  idUser: userId,
                ),
              ),
            );

          }else{
            showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Usuário não existe'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
          }
        }, falhaConexao);

  }


  falhaConexao(e) {
    print("Não foi possivel conectar-se ao banco - $e");
  }
}

class Comentario {
  String texto;
  int id;

  Comentario({required this.texto, required this.id});
}

class PaginaUsuario extends StatefulWidget {
  final String login;
  final String senha;
  final int idUser;

  PaginaUsuario({required this.login, required this.senha, required this.idUser});

  @override
  _PaginaUsuarioState createState() => _PaginaUsuarioState();
}

class _PaginaUsuarioState extends State<PaginaUsuario> {
  List<Comentario> comentarios = [];

  @override
  void initState() {
    super.initState();
    buscarComentarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Bloco de Notas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              adicionarComentario(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8.0),
            Text(
              widget.login,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: comentarios.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        comentarios[index].texto,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              editarComentario(context, comentarios[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              excluirComentario(context, comentarios[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buscarComentarios() async {
    Banco banco = Banco(falhaConexao);

    String consulta =
        "SELECT id_comment, comment_text FROM tb_comment WHERE id_user = ${widget.idUser} and use_flag='Y'";

    await banco.query(consulta, (numRegistros, result) {
      if (numRegistros > 0) {
        setState(() {
          comentarios = result!.map<Comentario>((registro) {
            String texto = registro["tb_comment"]["comment_text"].toString();
            int id = registro["tb_comment"]["id_comment"] as int;
            return Comentario(texto: texto, id: id);
          }).toList();
        });
      } else {
        //isso esta funcionando?????
        print("Nenhum comentário encontrado.");
        comentarios = [];

        //isso aqui não cria um loop infinito não????
          // MaterialPageRoute(
          //   builder: (context) => PaginaUsuario(
          //     login: widget.login,
          //     senha: widget.senha,
          //     idUser: widget.idUser,
          //   ),
          // );
      }
    }, falhaConexao);

    await banco.fecha();
  }

  void editarComentario(BuildContext context, Comentario comentario) async {
    TextEditingController controller = TextEditingController(text: comentario.texto);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Comentário'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Digite a edição do comentário',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                String novoTexto = controller.text;

                // setState(() {
                //   comentario.texto = novoTexto;
                // });

                Banco bancoUpdate = Banco(falhaConexao);
                String update = "UPDATE tb_comment SET use_flag = 'N' WHERE id_comment = ${comentario.id};";
                print(update);
                await bancoUpdate.query(update, (numRegistros, result) {buscarComentarios();}, falhaConexao);
                await bancoUpdate.fecha();

                Banco bancoInsert = Banco(falhaConexao);
                String insert = "INSERT INTO tb_comment (comment_text, id_user, use_flag) VALUES ('$novoTexto', ${widget.idUser}, 'Y');";
                print(insert);
                await bancoInsert.query(insert, (numRegistros, result) { buscarComentarios();}, falhaConexao);
                await bancoInsert.fecha();

                Navigator.of(context).pop();
                
              },
            ),
          ],
        );
      },
    );
  }

  void excluirComentario(BuildContext context, Comentario comentario) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Comentário'),
          content: Text('Deseja realmente excluir o comentário?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                Banco banco = Banco(falhaConexao);
                String delete = "update tb_comment set use_flag='N' WHERE id_comment = ${comentario.id};";
                print(delete);
                await banco.query(delete, (numRegistros, result) 
                {
                  setState(() {
                    comentarios.remove(comentario); // Remover o comentário pra não aparecer mais na tela
                  });
                  buscarComentarios();
                }, falhaConexao);
                await banco.fecha();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void adicionarComentario(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Comentário'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Digite o comentário',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Adicionar'),
              onPressed: () async {
                String texto = controller.text;

                Banco banco = Banco(falhaConexao);
                String insert = "INSERT INTO tb_comment (comment_text, id_user, use_flag) VALUES ('$texto', ${widget.idUser}, 'Y');";
                print(insert);
                await banco.query(insert, (numRegistros, result) {buscarComentarios();}, falhaConexao);
                await banco.fecha();

                //assim eu não tenho que buscar novamente os comentario, ja mostro na tela - deu ruim esta conflitando com os outros comentarios
                // setState(() {
                //   comentarios.add(Comentario(texto: texto, id: 0));
                // });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void falhaConexao(e) {
    print("Não foi possível conectar-se ao banco - $e");
  }
}

class NovoUsuarioPage extends StatelessWidget {
  //isso ta certo? credo
  //porque não funciona a entrada de texto?? sera que é a IDE online que faz isso??
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  
  var banco;

  @override
  Widget build(BuildContext context) {
     banco = Banco(falhaConexao);
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Cadastro Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // executa(context);
                adicionarUsuario(context);
               },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
  void falhaConexao(e) {
    print("Não foi possível conectar-se ao banco - $e");
  }
  // void adicionarUsuario(BuildContext context) async {
  //    // String comando = "select id_user from tb_user where login_user='victoria' and login_pass='123'";
  //   String login = _loginController.text;
  //   String pass = _passwordController.text;
  //   String comando = "insert into tb_user(login_user,login_pass) values ('$login','$pass')";

  //   Banco banco = Banco(falhaConexao);
  //   print(comando);
  //   await banco.query(comando, (numRegistros, result) {}, falhaConexao);
  //   await banco.fecha();

  // }

  void adicionarUsuario(BuildContext context) async {
  String login = _loginController.text;
  String pass = _passwordController.text;

  Banco banco = Banco(falhaConexao);

  // Verificar se o usuário já existe
  String consulta = "SELECT id_user FROM tb_user WHERE login_user = '$login'";
  await banco.query(consulta, (numRegistros, result) async {
    if (numRegistros > 0) {
      // Usuário já existe, exibir mensagem de erro
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Já existe um usuário com esse login.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Usuário não existe, inserir novo usuário
      String insert = "INSERT INTO tb_user (login_user, login_pass) VALUES ('$login', '$pass')";
      print(insert);

      Banco banco2 = Banco(falhaConexao);;
      await banco2.query(insert, (numRegistros, result) {
        // Usuário inserido com sucesso, exibir mensagem de sucesso
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sucesso'),
              content: Text('Faça login com seu novo usuário.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }, falhaConexao);
      banco2.fecha();
    }
  }, falhaConexao);

  await banco.fecha();
}

}