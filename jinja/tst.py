from jinja2 import Environment, PackageLoader
env = Environment(
    loader=PackageLoader('myapp','templates')
    )
template = env.get_template('tst.j2')
print(template.render(the='variables',g='here', p="Not the default"))
