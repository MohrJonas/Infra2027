[
  {
    name = "Update package sources";
    "ansible.builtin.apt" = {
      update_cache = true;
    };
    become = true;
  }
  {
    name = "Upgrade all installed packages";
    "ansible.builtin.apt" = {
      package = "*";
      state = "latest";
    };
    become = true;
  }
]
