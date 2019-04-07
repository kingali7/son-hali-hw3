# CSCI3180 Principles of Programming Languages
 #
 # --- Declaration ---
 #
 # I declare that the assignment here submitted is original except for source
 # material explicitly acknowledged. I also acknowledge that I am aware of
 # University policy and regulations on honesty in academic work, and of the
 # disciplinary guidelines and procedures applicable to breaches of such policy
 # and regulations, as contained in the website
 # http://www.cuhk.edu.hk/policy/academichonesty/
 #
 # I have borrowed some function codes from my rommate Huzeyfe Kıran(Huzoo) 1155104019
 #
 # Assignment 3
 # Name : Alshir Soyunjov
 # Student ID : 1155119170
 # Email Addr : 1155119170@link.cuhk.edu.hk
use strict;
use warnings;
require "./maze_race_components.pm";

package MazeRace;

sub new{
  my ($class, $file) = @_;
  my $maze = Maze->new();
  my $p1 = Player->new();
  my $p2 = Player->new();

  $p1->setName('E');
  $p2->setName('H');
  if(open(my $fh, '<:encoding(UTF-8)', $file)){
    my @coords = $maze->loadMaze($fh);

    $p1->getPos()->setR(int($coords[0]));
    $p1->getPos()->setC(int($coords[1]));
    $p2->getPos()->setR(int($coords[2]));
    $p2->getPos()->setC(int($coords[3]));

    $maze->explore($p1->getPos());
    $maze->explore($p2->getPos());
  }
  else{
    die "Could not load file $file";
  }

  my $self = {
    maze => $maze,
    p1 => $p1,
    p2 => $p2,
  };
  return bless $self, $class;
}

sub start{
  my $self = shift;
  my $maze = $self->{maze};
  $maze->displayMaze();

  my @pArr = ($self->{p1}, $self->{p2});
  my $turn = 0;
  my $finished = 0;
  while($finished eq 0){
    $pArr[$turn]->makeMove($maze);
    $maze->displayMaze();
    if($maze->reachDest($pArr[$turn]->getPos())){
      my $i = $turn+1;
      print "\n--\nPlayer".$i." wins! \n";
      $finished = 1;
    }
    $turn = ($turn+1)%2;
  }
}

package main;
my $config_file = "maze.test";
my $game = MazeRace->new($config_file);
$game->start();
