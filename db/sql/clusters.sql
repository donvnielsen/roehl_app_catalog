-- auto-generated definition
create table clusters
(
  id          integer  not null
    primary key
    autoincrement,
  name        varchar,
  description varchar,
  created_at  datetime not null,
  updated_at  datetime not null
);

INSERT INTO clusters (id, name, description, created_at, updated_at) VALUES (1, 'mfdac0001', null, '2018-06-02 15:02:51.717199', '2018-06-02 15:02:51.717199');
INSERT INTO clusters (id, name, description, created_at, updated_at) VALUES (2, 'mfdac0002.rti.roehl.net', null, '2018-06-02 15:02:51.812885', '2018-06-02 15:02:51.812885');