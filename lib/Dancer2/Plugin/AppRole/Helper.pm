package Dancer2::Plugin::AppRole::Helper;

use strictures 2;

# VERSION

# ABSTRACT: helper functions for creating Dancer2 AppRole plugins

# COPYRIGHT

=head1 SYNOPSIS

In your plugin:

    package Dancer2::Plugin::Mine;

    use Dancer2::Plugin;
    use Dancer2::EnsureAppRole;

    # short version
    on_plugin_import { ensure_approle_s "Mine", @_ };

    # OR long and/or customized version
    on_plugin_import { ensure_approle "Dancer2::Plugin::AppRole::Mine", @_ };

    # ...

In your Dancer module:

    package MyDancerApp;

    use Dancer2;

    use Dancer2::Plugin::Mine; # loads and applies the role to the app object
    use Dancer2::Plugin::Mine; # does *not* do it again

    use MyDancerSubModule;

In a submodule:

    package MyDancerSubModule;

    use Dancer2 appname => 'MyDancerApp';

    use Dancer2::Plugin::Mine; # does *not* do it again either, but would if
                               # the submodule is loaded on its own

=cut

use parent 'Exporter';

our @EXPORT = qw(ensure_approle ensure_approle_s);

=head1 FUNCTIONS

=head2 ensure_approle

Apply the given role to the app in the given Dancer2 DSL object, but don't
apply it twice.

=cut

sub ensure_approle {
    my ( $role, $dsl ) = @_;
    my $app = $dsl->app;
    return if $app->does( $role );
    Moo::Role->apply_roles_to_object( $app, $role );
}

=head2 ensure_approle_s

Same as ensure_approle, but C<Dancer2::Plugin::AppRole::> is prepended on the
role name for shorter calling.

=cut

sub ensure_approle_s { ensure_approle "Dancer2::Plugin::AppRole::" . shift, @_ }

1;
