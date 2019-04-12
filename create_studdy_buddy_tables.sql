create table if not exists jkunnum1_studdyBuddyUsers.users (
	userID int(11) not null auto_increment,
	username varchar(64),
	password varchar(64),
	primary key (userID)
);

create table if not exists jkunnum1_studdyBuddyUsers.studySessions (
	studyID int(11) not null auto_increment,
	creatorID int(11),
	studyTime datetime,
	subject varchar(32),
	location varchar(64),
	primary key (studyID),
	foreign key (creatorID) references jkunnum1_studdyBuddyUsers.users (userID)
);
