class Conta{
  int id;
  String dono;
  double val;
  String nome;
  String date;
  bool feita;

  Conta(int id, String dono, double val, String nome, String date, int feita){
    this.id = id;
    this.dono = dono;
    this.val = val;
    this.nome = nome;
    this.date = date;
    if(feita == 1)
      this.feita = true;
    else
      this.feita = false;
  }
}