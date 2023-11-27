
create table tb_orcamentos (
    orcamento_id integer primary key,
    orcamento_valor real,
    orcamento_mes integer,
    orcamento_ano integer
);

create table tb_contas (
   conta_id integer primary key,
   conta_descricao text,
   conta_valor real,
   conta_pago text,
   conta_recibo blob,
   orcamento_id integer,
   foreign key (orcamento_id) references tb_orcamentos (orcamento_id)
);