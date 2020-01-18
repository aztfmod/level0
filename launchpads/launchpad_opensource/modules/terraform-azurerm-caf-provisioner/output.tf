output "library" {
    value = {
        for script in  keys(local.scripts):

        script => local.scripts[script]
    }
}