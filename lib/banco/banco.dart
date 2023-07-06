import 'package:postgres/postgres.dart';

class Banco {
  PostgreSQLConnection? _conexao;

  List<Map<String, Map<String, dynamic>>>? _result;
  int? _numRegistros;

  Banco(Function rotinaFalha,
      {String url = '200.19.1.18',
      int porta = 5432,
      String banco = 'victoriacaetano',
      String usuario = 'victoriacaetano',
      String senha = '123456'}) {
    try {
      _conexao = PostgreSQLConnection(url, porta, banco,
          username: usuario, password: senha);
    } catch (e) {
      rotinaFalha(e.toString());
    }
  }

  fecha() async {
    await _conexao?.close();
  }

  Future<void> query(
      String comando, Function funcao, Function funcaoErro) async {
    try {
      await _conexao?.open();
      _result = null;
      List<Map<String, Map<String, dynamic>>>? result =
          await _conexao?.mappedResultsQuery(comando);
      _result = result;
      _numRegistros = result?.length;
      funcao(_numRegistros, _result);
    } catch (e) {
      funcaoErro(e);
    } finally {
      // Somente fecha a conexão se ela estiver aberta
      if (_conexao != null && !_conexao!.isClosed) {
        await fecha();
      }
    }
  }
}
