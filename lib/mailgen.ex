defmodule Mailgen do
  @moduledoc """
  Documentation for `Mailgen`.
  """

  @base Application.app_dir(:mailgen) <> "/priv/templates/"

  @doc """

  ## Examples
      iex> Mailgen.generate!(
        %{theme: "default",
          title: "Hello world",
          product: %{name: "Trenr", link: "http://www.trenr.me"},
          intro: ['Welcome to Mailgen! We\'re very excited to have you on board.'],
          outro: ['Need help, or have questions? Just reply to this email, we\'d love to help.'],
          dictionary: %{
            date: "June 11th, 2016",
            address: "123 Park Avenue, Miami, Florida"
          },
          table: [%{
            title: "hello",
            data: [
              %{
                  item: "Node.js",
                  description: "Event-driven I/O server-side JavaScript environment based on V8.",
                  price: "$10.99"
              },
              %{
                  item: "Mailgen",
                  description: "Programmatically create beautiful e-mails using plain old JavaScript.",
                  price: "$1.99"
              }
            ],
            columns: %{
              custom_width: %{
                item: '20%',
                  price: '15%'
                },
              custom_alignment: %{
                price: 'right'
              }
            },
          }],
          action: [%{
            instructions: 'To get started with Mailgen, please click here:',
            button: [%{
              color: '#22BC66', #optionnal
              text: 'Confirm your account',
              link: 'https://mailgen.js/confirm?s=d9729feb74992cc3482b350163a1a010'}]}]})
      %{html: "....", text: "......"}

  """
  def generate!(
        %{
          theme: "default",
          title: title,
          product: %{name: name, link: link} = product
        } = params
      ) do
    action = Map.get(params, :action, [])
    table = Map.get(params, :table, [])
    intro = Map.get(params, :intro, [])
    outro = Map.get(params, :outro, [])
    dictionary = Map.get(params, :dictionary, [])

    templates = %{
      "default.html" => EEx.compile_file(@base <> "default.html.eex"),
      "default.txt" => EEx.compile_file(@base <> "default.txt.eex")
    }

    data = [
      go_to_action: %{
        link: "",
        text: "",
        description: ""
      },
      title: title,
      action: action,
      signature: "Best regards",
      intro: intro,
      outro: outro,
      table: table,
      dictionary: dictionary,
      product: product,
      text_direction: "ltr"
    ]

    {html, _} = Code.eval_quoted(Map.get(templates, "default.html"), data)
    {text, _} = Code.eval_quoted(Map.get(templates, "default.txt"), data)

    %{
      html: html,
      text: text
    }
  end
end
