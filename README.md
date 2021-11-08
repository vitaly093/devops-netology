Ответы на вопросы:

1.  Ответ: полный хеш коммита: aefead2207ef7e2aa5dc81a34aedf0cad4c32545, комментарий Update CHANGELOG.md.

Объяснение: для поиска коммита по его хешу и выводу информации о комментарии к коммиту, я использовал следующую команду:

vfkuhtenko@S:~/netology/DevOps/terraform$ git log aefea -1 --pretty=full
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Commit: GitHub <noreply@github.com>

    Update CHANGELOG.md

2. Ответ: tag: v0.12.23

Объяснение: в данном случае также использовал команду git log с аргументом 85024d3, дополнительных опций указывать не потребовалось, так как лог коммита уже содержит информацию о теге:
vfkuhtenko@S:~/netology/DevOps/terraform$ git log 85024d3 -1
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23

3. Ответ: у коммита b8d720 2 родителя. Сокращенные хеши родителей: 56cd7859e 9ea88f22f.
Объяснение: для просмотра информации о конкретном коммите можно использовать также команду git show с указанием хеша коммита:
vfkuhtenko@S:~/netology/DevOps/terraform$ git show b8d720
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: 56cd7859e 9ea88f22f
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Jan 21 17:45:48 2020 -0800

    Merge pull request #23916 from hashicorp/cgriggs01-stable

    [Cherrypick] community links

4. Ответ: для вывода диапазона коммитов можно воспользоваться функционалом "двух точек" или "множества точек", перед двумя точками можно указать тег с которого начинается диапазон, а после - тег на котором диапазон заканчивается, вот вывод данной команды, в которой есть все хеши и комментарии к коммитами между указанными тегами:
vfkuhtenko@S:~/netology/DevOps/terraform$ git log v0.12.23..v0.12.24
commit 33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 19 15:04:05 2020 +0000

    v0.12.24

commit b14b74c4939dcab573326f4e3ee2a62e23e12f89
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Mar 10 08:59:20 2020 -0700

    [Website] vmc provider links

commit 3f235065b9347a758efadc92295b540ee0a5e26e
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Mar 19 10:39:31 2020 -0400

    Update CHANGELOG.md

commit 6ae64e247b332925b872447e9ce869657281c2bf
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Mar 19 10:20:10 2020 -0400

    registry: Fix panic when server is unreachable

    Non-HTTP errors previously resulted in a panic due to dereferencing the
    resp pointer while it was nil, as part of rendering the error message.
    This commit changes the error message formatting to cope with a nil
    response, and extends test coverage.

    Fixes #24384

commit 5c619ca1baf2e21a155fcdb4c264cc9e24a2a353
Author: Nick Fagerlund <nick.fagerlund@gmail.com>
Date:   Wed Mar 18 12:30:20 2020 -0700

    website: Remove links to the getting started guide's old location

    Since these links were in the soon-to-be-deprecated 0.11 language section, I
    think we can just remove them without needing to find an equivalent link.

commit 06275647e2b53d97d4f0a19a0fec11f6d69820b5
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Wed Mar 18 10:57:06 2020 -0400

    Update CHANGELOG.md

commit d5f9411f5108260320064349b757f55c09bc4b80
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Tue Mar 17 13:21:35 2020 -0400

    command: Fix bug when using terraform login on Windows

commit 4b6d06cc5dcb78af637bbb19c198faff37a066ed
Author: Pam Selle <pam@hashicorp.com>
Date:   Tue Mar 10 12:04:50 2020 -0400

    Update CHANGELOG.md

commit dd01a35078f040ca984cdd349f18d0b67e486c35
Author: Kristin Laemmert <mildwonkey@users.noreply.github.com>
Date:   Thu Mar 5 16:32:43 2020 -0500

    Update CHANGELOG.md

commit 225466bc3e5f35baa5d07197bbc079345b77525e
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 21:12:06 2020 +0000

    Cleanup after v0.12.23 release


5. Ответ: функция func providerSource была создана в коммите:
commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Thu Apr 2 18:04:39 2020 -0700

Объяснение: чтобы найти в истории коммитов (в логе) данные об этой функции, сначала нужно найти файл в котором она определена, для этого воспользуемся следующей командой: vfkuhtenko@S:~/netology/DevOps/terraform$ git grep -n 'func providerSource'
provider_source.go:23:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
provider_source.go:187:func providerSourceForCLIConfigLocation(loc cliconfig.ProviderInstallationLocation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
Видно, что функция содержится в файле provider_source.go

Далее воспользуемся функционалом опции -L в команде git log:

vfkuhtenko@S:~/netology/DevOps/terraform$ git log -L :providerSource:provider_source.go
commit 5af1e6234ab6da412fb8637393c5a17a1b293663
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Tue Apr 21 16:28:59 2020 -0700

    main: Honor explicit provider_installation CLI config when present

    If the CLI configuration contains a provider_installation block then we'll
    use the source configuration it describes instead of the implied one we'd
    build otherwise.

diff --git a/provider_source.go b/provider_source.go
--- a/provider_source.go
+++ b/provider_source.go
@@ -20,6 +23,15 @@
-func providerSource(services *disco.Disco) getproviders.Source {
-       // We're not yet using the CLI config here because we've not implemented
-       // yet the new configuration constructs to customize provider search
-       // locations. That'll come later. For now, we just always use the
-       // implicit default provider source.
-       return implicitProviderSource(services)
+func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
+       if len(configs) == 0 {
+               // If there's no explicit installation configuration then we'll build
+               // up an implicit one with direct registry installation along with
+               // some automatically-selected local filesystem mirrors.
+               return implicitProviderSource(services), nil
+       }
+
+       // There should only be zero or one configurations, which is checked by
+       // the validation logic in the cliconfig package. Therefore we'll just
+       // ignore any additional configurations in here.
+       config := configs[0]
+       return explicitProviderSource(config, services)
+}
+

commit 92d6a30bb4e8fbad0968a9915c6d90435a4a08f6
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed Apr 15 11:48:24 2020 -0700

    main: skip direct provider installation for providers available locally

    This more closely replicates the 0.12-and-earlier behavior, where having
    at least one version of a provider installed locally would totally disable
    any attempt to look for newer versions remotely.

    This is just for the implicit default behavior. Assumption is that later
    we'll have an explicit configuration mechanism that will allow the user
    to specify exactly where to look for what, and thus avoid tricky
    heuristics like this.

diff --git a/provider_source.go b/provider_source.go
--- a/provider_source.go
+++ b/provider_source.go
@@ -19,5 +20,6 @@
 func providerSource(services *disco.Disco) getproviders.Source {
        // We're not yet using the CLI config here because we've not implemented
        // yet the new configuration constructs to customize provider search
-       // locations. That'll come later.
-       // For now, we have a fixed set of search directories:
+       // locations. That'll come later. For now, we just always use the
+       // implicit default provider source.
+       return implicitProviderSource(services)

commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Thu Apr 2 18:04:39 2020 -0700

    main: Consult local directories as potential mirrors of providers

    This restores some of the local search directories we used to include when
    searching for provider plugins in Terraform 0.12 and earlier. The
    directory structures we are expecting in these are different than before,
    so existing directory contents will not be compatible without
    restructuring, but we need to retain support for these local directories
    so that users can continue to sideload third-party provider plugins until
    the explicit, first-class provider mirrors configuration (in CLI config)
    is implemented, at which point users will be able to override these to
    whatever directories they want.

    This also includes some new search directories that are specific to the
    operating system where Terraform is running, following the documented
    layout conventions of that platform. In particular, this follows the
    XDG Base Directory specification on Unix systems, which has been a
    somewhat-common request to better support "sideloading" of packages via
    standard Linux distribution package managers and other similar mechanisms.
    While it isn't strictly necessary to add that now, it seems ideal to do
    all of the changes to our search directory layout at once so that our
    documentation about this can cleanly distinguish "0.12 and earlier" vs.
    "0.13 and later", rather than having to document a complex sequence of
    smaller changes.

    Because this behavior is a result of the integration of package main with
    package command, this behavior is verified using an e2etest rather than
    a unit test. That test, TestInitProvidersVendored, is also fixed here to
    create a suitable directory structure for the platform where the test is
    being run. This fixes TestInitProvidersVendored.

diff --git a/provider_source.go b/provider_source.go
--- /dev/null
+++ b/provider_source.go
@@ -0,0 +19,5 @@
+func providerSource(services *disco.Disco) getproviders.Source {
+       // We're not yet using the CLI config here because we've not implemented
+       // yet the new configuration constructs to customize provider search
+       // locations. That'll come later.
+       // For now, we have a fixed set of search directories:

Видно, что самый первый коммит, где была создана функция это коммит vfkuhtenko@SC-WS-00042:~/netology/DevOps/terraform$ git log -L :providerSource:provider_source.go
commit 5af1e6234ab6da412fb8637393c5a17a1b293663
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Tue Apr 21 16:28:59 2020 -0700

    main: Honor explicit provider_installation CLI config when present

    If the CLI configuration contains a provider_installation block then we'll
    use the source configuration it describes instead of the implied one we'd
    build otherwise.

diff --git a/provider_source.go b/provider_source.go
--- a/provider_source.go
+++ b/provider_source.go
@@ -20,6 +23,15 @@
-func providerSource(services *disco.Disco) getproviders.Source {
-       // We're not yet using the CLI config here because we've not implemented
-       // yet the new configuration constructs to customize provider search
-       // locations. That'll come later. For now, we just always use the
-       // implicit default provider source.
-       return implicitProviderSource(services)
+func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
+       if len(configs) == 0 {
+               // If there's no explicit installation configuration then we'll build
+               // up an implicit one with direct registry installation along with
+               // some automatically-selected local filesystem mirrors.
+               return implicitProviderSource(services), nil
+       }
+
+       // There should only be zero or one configurations, which is checked by
+       // the validation logic in the cliconfig package. Therefore we'll just
+       // ignore any additional configurations in here.
+       config := configs[0]
+       return explicitProviderSource(config, services)
+}
+

commit 92d6a30bb4e8fbad0968a9915c6d90435a4a08f6
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed Apr 15 11:48:24 2020 -0700

    main: skip direct provider installation for providers available locally

    This more closely replicates the 0.12-and-earlier behavior, where having
    at least one version of a provider installed locally would totally disable
    any attempt to look for newer versions remotely.

    This is just for the implicit default behavior. Assumption is that later
    we'll have an explicit configuration mechanism that will allow the user
    to specify exactly where to look for what, and thus avoid tricky
    heuristics like this.

diff --git a/provider_source.go b/provider_source.go
--- a/provider_source.go
+++ b/provider_source.go
@@ -19,5 +20,6 @@
 func providerSource(services *disco.Disco) getproviders.Source {
        // We're not yet using the CLI config here because we've not implemented
        // yet the new configuration constructs to customize provider search
-       // locations. That'll come later.
-       // For now, we have a fixed set of search directories:
+       // locations. That'll come later. For now, we just always use the
+       // implicit default provider source.
+       return implicitProviderSource(services)

commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Thu Apr 2 18:04:39 2020 -0700

    main: Consult local directories as potential mirrors of providers

    This restores some of the local search directories we used to include when
    searching for provider plugins in Terraform 0.12 and earlier. The
    directory structures we are expecting in these are different than before,
    so existing directory contents will not be compatible without
    restructuring, but we need to retain support for these local directories
    so that users can continue to sideload third-party provider plugins until
    the explicit, first-class provider mirrors configuration (in CLI config)
    is implemented, at which point users will be able to override these to
    whatever directories they want.

    This also includes some new search directories that are specific to the
    operating system where Terraform is running, following the documented
    layout conventions of that platform. In particular, this follows the
    XDG Base Directory specification on Unix systems, which has been a
    somewhat-common request to better support "sideloading" of packages via
    standard Linux distribution package managers and other similar mechanisms.
    While it isn't strictly necessary to add that now, it seems ideal to do
    all of the changes to our search directory layout at once so that our
    documentation about this can cleanly distinguish "0.12 and earlier" vs.
    "0.13 and later", rather than having to document a complex sequence of
    smaller changes.

    Because this behavior is a result of the integration of package main with
    package command, this behavior is verified using an e2etest rather than
    a unit test. That test, TestInitProvidersVendored, is also fixed here to
    create a suitable directory structure for the platform where the test is
    being run. This fixes TestInitProvidersVendored.

diff --git a/provider_source.go b/provider_source.go
--- /dev/null
+++ b/provider_source.go
@@ -0,0 +19,5 @@
+func providerSource(services *disco.Disco) getproviders.Source {
+       // We're not yet using the CLI config here because we've not implemented
+       // yet the new configuration constructs to customize provider search
+       // locations. That'll come later.
+       // For now, we have a fixed set of search directories:
Видно, что самый первый коммит, где были добавлены строки про данную функцию, это коммит commit 8c928e83589d90a031f811fae52a81be7153e82f



6. Ответ: коммиты, в которых была изменена функция globalPluginDirs: 66ebff90cdfaa6938f26f908c7ebad8d547fea17, 41ab0aef7a0fe030e84018973a64135b11abcd70, 52dbf94834cb970b510f2fba853a5b49ad9b1a46, 78b12205587fe839f10d946ea3fdc06719decb05.

Объяснение: как и в предыдущем случае, сначала был определен файл, в котором эта функция находится через git grep -n 'git grep -n 'func globalPluginDirs', далее при помощи git log -L :globalPluginDirs:plugins.go: были найдены все коммиты, в которых эта функция изменялась или создавалась. Самый первый коммит в ответ не включен, так как в нем она именно создавалась а не изменялась.


7. Ответ: автор функции synchronized writers - Martin Atkins <mart@degeneration.co.uk>.
Объяснение: стандартным поиском по функции или по строчке 'func synchronizedWriters' как в предыдущих примерах воспользоваться не удалось, поиск не давал результатов.
Но результат нашелся при помощи: 
vfkuhtenko@S:~/netology/DevOps/terraform$ git log -SsynchronizedWriters

В результате выполнения команды выше найден коммит:
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700

    main: synchronize writes to VT100-faker on Windows

    We use a third-party library "colorable" to translate VT100 color
    sequences into Windows console attribute-setting calls when Terraform is
    running on Windows.

    colorable is not concurrency-safe for multiple writes to the same console,
    because it writes to the console one character at a time and so two
    concurrent writers get their characters interleaved, creating unreadable
    garble.

    Here we wrap around it a synchronization mechanism to ensure that there
    can be only one Write call outstanding across both stderr and stdout,
    mimicking the usual behavior we expect (when stderr/stdout are a normal
    file handle) of each Write being completed atomically.

Далее из информации в данном коммите видно, что был добавлен файл synchronized_writers.go и у данного коммита автор - Martin Atkins <mart@degeneration.co.uk>

vfkuhtenko@SC-WS-00042:~/netology/DevOps/terraform$ git show 5ac311e2a91e381e2f52234668b49ba670aa0fe5
commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700

    main: synchronize writes to VT100-faker on Windows

    We use a third-party library "colorable" to translate VT100 color
    sequences into Windows console attribute-setting calls when Terraform is
    running on Windows.

    colorable is not concurrency-safe for multiple writes to the same console,
    because it writes to the console one character at a time and so two
    concurrent writers get their characters interleaved, creating unreadable
    garble.

    Here we wrap around it a synchronization mechanism to ensure that there
    can be only one Write call outstanding across both stderr and stdout,
    mimicking the usual behavior we expect (when stderr/stdout are a normal
    file handle) of each Write being completed atomically.

diff --git a/main.go b/main.go
index b94de2ebc..237581200 100644
--- a/main.go
+++ b/main.go
@@ -258,6 +258,15 @@ func copyOutput(r io.Reader, doneCh chan<- struct{}) {
        if runtime.GOOS == "windows" {
                stdout = colorable.NewColorableStdout()
                stderr = colorable.NewColorableStderr()
+
+               // colorable is not concurrency-safe when stdout and stderr are the
+               // same console, so we need to add some synchronization to ensure that
+               // we can't be concurrently writing to both stderr and stdout at
+               // once, or else we get intermingled writes that create gibberish
+               // in the console.
+               wrapped := synchronizedWriters(stdout, stderr)
+               stdout = wrapped[0]
+               stderr = wrapped[1]
        }

        var wg sync.WaitGroup
diff --git a/synchronized_writers.go b/synchronized_writers.go
new file mode 100644
index 000000000..2533d1316
--- /dev/null
+++ b/synchronized_writers.go
@@ -0,0 +1,31 @@
+package main
+
+import (
+       "io"
+       "sync"
+)
+
+type synchronizedWriter struct {
+       io.Writer
+       mutex *sync.Mutex
+}
+
+// synchronizedWriters takes a set of writers and returns wrappers that ensure
+// that only one write can be outstanding at a time across the whole set.
+func synchronizedWriters(targets ...io.Writer) []io.Writer {
+       mutex := &sync.Mutex{}
+       ret := make([]io.Writer, len(targets))
+       for i, target := range targets {
+               ret[i] = &synchronizedWriter{
+                       Writer: target,
+                       mutex:  mutex,
+               }
+       }
+       return ret
+}
+
+func (w *synchronizedWriter) Write(p []byte) (int, error) {
+       w.mutex.Lock()
+       defer w.mutex.Unlock()
+       return w.Writer.Write(p)
+}
