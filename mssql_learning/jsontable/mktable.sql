use tdba;
drop table if exists tdba.IssueList;
create table tdba.IssueList
(
  Id int IDENTITY(1,1) PRIMARY KEY,
  JsonData nvarchar(500)
);
