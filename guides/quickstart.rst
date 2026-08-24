|section-titles__quickstart|
============================

С помощью быстрого старта вы установите и настроите Terraform-провайдер для работы с ресурсами :filter:`<public>|names__company| |names__evo|.` :filter:`<private>|names__evo-stack|.`

Установка Terraform
-------------------

`Установите Terraform <https://developer.hashicorp.com/terraform/install>`__, если он еще не установлен.

1. Скачайте исполняемый файл Terraform, совместимый с операционной
   системой и архитектурой процессора вашего компьютера.

2. Установите Terraform в удобную для вас директорию.

3. Назначьте права пользователя, необходимые для запуска исполняемого
   файла.
   
4. Расширьте переменную окружения ``PATH``, чтобы исполняемый файл
   Terraform был доступен для вызова из терминала.

.. _quickstart__setup-provider:

Установка провайдера
--------------------

Выберите нужный вариант в зависимости от архитектуры и операционной
системы вашего компьютера.

Создание директории для провайдера
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Создайте папку cloudru для исполняемого файла Terraform-провайдера
   внутри вашей домашней директории:

.. code:: bash

   cd ~ && mkdir -p .terraform.d/plugins/cloud.ru/cloudru/cloud/2.1.2

2. Внутри этой директории создайте папку под бинарный файл нужной
   платформы:

   -  ``darwin_arm64`` (для Mac с процессором Apple)
   -  ``darwin_amd64`` (для Mac с процессором Intel)
   -  ``linux_amd64`` (для Linux x64)
   -  ``linux_arm`` (для Linux ARM)
   -  ``windows_amd64`` (для Windows 10/11 x64)

Скачивание провайдера
~~~~~~~~~~~~~~~~~~~~~

.. tabs::

   .. tab:: Mac (Apple)

     #. Для скачивания провайдера, выполните следующую команду:

        .. include:: ../_warehouse/text-blocks-outline.rsti
           :start-after: {{start-after text-blocks-outline__code-block-mac-arm64}}
           :end-before: {{end-before text-blocks-outline__code-block-mac-arm64}}
        
     #. Перейдите в каталог с вашими .tf файлами и выполните команду:
     
        .. code-block:: 

            terraform init

   .. tab:: Mac (Intel)

     #. Для скачивания провайдера, выполните следующую команду:      
     
        .. include:: ../_warehouse/text-blocks-outline.rsti
           :start-after: {{start-after text-blocks-outline__code-block-mac-amd64}}
           :end-before: {{end-before text-blocks-outline__code-block-mac-amd64}}
        
     #. Перейдите в каталог с вашими .tf файлами и выполните команду:
     
        .. code-block:: 

           terraform init 

   .. tab:: Linux (x64)

     #. Для скачивания провайдера, выполните следующую команду:

        .. include:: ../_warehouse/text-blocks-outline.rsti
           :start-after: {{start-after text-blocks-outline__code-block-linux}}
           :end-before: {{end-before text-blocks-outline__code-block-linux}}
        
     #. Перейдите в каталог с вашими .tf файлами и выполните команду:
     
        .. code-block:: 

            terraform init 

   .. tab:: Windows 10/11 (x64)

     #. Для скачивания провайдера, выполните следующую команду:

        .. include:: ../_warehouse/text-blocks-outline.rsti
           :start-after: {{start-after text-blocks-outline__code-block-win}}
           :end-before: {{end-before text-blocks-outline__code-block-win}}
        
     #. Перейдите в каталог с вашими .tf файлами и выполните команду:
     
        .. code-block:: 

           terraform init 

     Исполняемые файлы провайдера доступны в `репозитории <https://github.com/CLOUDdotRu/evo-terraform/releases>`__.

Инициализация Terraform
~~~~~~~~~~~~~~~~~~~~~~~

Перейдите в каталог с вашими .tf файлами и выполните команду:

.. code:: rst

   .. code-block:: bash

      terraform init

Настройка провайдера
--------------------

Получение необходимых данных
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Получите следующие данные:

-  `Ключи доступа сервисного
   аккаунта <https://cloud.ru/docs/console_api/ug/topics/guides__service_accounts_key>`__
-  `ID
   проекта <https://cloud.ru/docs/administration/ug/topics/guides__projects>`__

.. only:: private

      .. attention::
   
         В частном облаке |names__evo-stack| с Terraform работают только сервисы IAM, Evolution и MCM.
         Чтобы работать с ними, замените эндпоинты в файле :file:`main.tf` на следующие:
         
         — ``api.evo.stack.dev/iam``
         
         — ``api.evo.stack.dev/compute``
         
         — ``api.evo.stack.dev/mcm``
         
         Где ``evo.stack.dev`` --- доменное имя, выбранное в вашей компании.

Создание файла конфигурации
~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Создайте папку под Terraform-проект, в котором будете конфигурировать
   ресурсы.
2. Создайте в папке файл ``main.tf``. Пример содержимого файла вы можете
   найти в нашем официальном
   `GitHub-репозитории <https://github.com/CLOUDdotRu/evo-terraform/tree/main/reference>`__.

Настройка параметров
~~~~~~~~~~~~~~~~~~~~

1. Создайте сервисный аккаунт и выпустите для него ключ `по
   инструкции <https://cloud.ru/docs/console_api/ug/topics/guides__api_key?source-platform=Evolution>`__.
2. В файле ``main.tf`` в секции ``provider`` укажите значения параметров
   ``auth_key_id`` и ``auth_secret``, полученные на предыдущем шаге.
3. В секции ``provider`` заполните параметр ``project_id``, указав в нем
   идентификатор вашего проекта в облаке Cloud.ru.

Инициализация проекта
~~~~~~~~~~~~~~~~~~~~~

Проинициализируйте Terraform, выполнив команду:

.. code:: rst

   .. code-block:: bash

      terraform init

Результат
~~~~~~~~~

Вы настроили Terraform-провайдер и сможете использовать `файлы с примерами кода <https://github.com/CLOUDdotRu/evo-terraform/tree/main/reference>`__ для работы с ресурсами |names__company| |names__evo|.