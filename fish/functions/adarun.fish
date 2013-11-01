function adarun
  set program $argv;

  rm *.o;

  gnat make $program > /dev/null 2>&1;
  and eval "./$program";
end
