-- auto-generated definition
create table application_types
(
  id          integer  not null
    primary key
    autoincrement,
  name        varchar,
  description varchar,
  created_at  datetime not null,
  updated_at  datetime not null
);

INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (2, 'access', null, '2018-06-01 02:05:24.412380', '2018-06-01 02:05:24.412380');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (3, 'deploymentplaceholder', null, '2018-06-01 02:05:24.415553', '2018-06-01 02:05:24.415553');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (4, 'fullyoutsourced', null, '2018-06-01 02:05:24.420011', '2018-06-01 02:05:24.420011');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (5, 'publicwebapp', null, '2018-06-01 02:05:24.424072', '2018-06-01 02:05:24.424072');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (6, 'scheduledtask', null, '2018-06-01 02:05:24.427826', '2018-06-01 02:05:24.427826');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (7, 'wcfservice', null, '2018-06-01 02:05:24.431035', '2018-06-01 02:05:24.431035');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (8, 'webapp', null, '2018-06-01 02:05:24.434716', '2018-06-01 02:05:24.434716');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (9, 'webservice', null, '2018-06-01 02:05:24.438378', '2018-06-01 02:05:24.438378');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (10, 'windowsapp', null, '2018-06-01 02:05:24.441462', '2018-06-01 02:05:24.441462');
INSERT INTO application_types (id, name, description, created_at, updated_at) VALUES (11, 'windowsservice', null, '2018-06-01 02:05:24.445362', '2018-06-01 02:05:24.445362');